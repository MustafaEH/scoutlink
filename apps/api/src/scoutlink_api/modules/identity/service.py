from datetime import UTC, date, datetime

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from scoutlink_api.core.auth import Principal
from scoutlink_api.modules.identity.models import (
    ConsentRecord,
    GuardianRelationship,
    Player,
    RecruiterProfile,
    RoleName,
    User,
    UserRole,
)
from scoutlink_api.modules.identity.schemas import (
    CompleteOnboardingRequest,
    GuardianPlayerCreate,
    IdentityResponse,
)

SELF_ASSIGNABLE_ROLES = {
    RoleName.PLAYER,
    RoleName.GUARDIAN,
    RoleName.RECRUITER,
    RoleName.ACADEMY_REPRESENTATIVE,
}


def age_on(birth_date: date, on_date: date) -> int:
    return (
        on_date.year
        - birth_date.year
        - ((on_date.month, on_date.day) < (birth_date.month, birth_date.day))
    )


def validate_role_selection(existing_roles: set[RoleName], role: RoleName) -> None:
    if role not in SELF_ASSIGNABLE_ROLES:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "code": "role_not_self_assignable",
                "message": "This role requires staff approval.",
            },
        )
    if existing_roles and role not in existing_roles:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={
                "code": "role_already_selected",
                "message": "Changing the account role requires platform support.",
            },
        )


async def get_or_create_user(session: AsyncSession, principal: Principal) -> User:
    user = await session.get(User, principal.user_id, options=[selectinload(User.roles)])
    if user is None:
        user = User(id=principal.user_id, email=principal.email)
        session.add(user)
        await session.flush()
        user.roles = []
    elif user.email != principal.email:
        user.email = principal.email
    return user


async def identity_response(session: AsyncSession, user: User) -> IdentityResponse:
    recruiter = await session.get(RecruiterProfile, user.id)
    return IdentityResponse(
        id=user.id,
        email=user.email,
        full_name=user.full_name,
        username=user.username,
        onboarding_complete=user.onboarding_completed_at is not None,
        status=user.status,
        roles=[assignment.role for assignment in user.roles],
        recruiter_verification=recruiter.verification_status if recruiter else None,
    )


async def select_role(session: AsyncSession, user: User, role: RoleName) -> IdentityResponse:
    existing_roles = {assignment.role for assignment in user.roles}
    validate_role_selection(existing_roles, role)
    if role not in existing_roles:
        session.add(UserRole(user_id=user.id, role=role))
        if role == RoleName.RECRUITER:
            session.add(RecruiterProfile(user_id=user.id))
        await session.commit()
        await session.refresh(user, attribute_names=["roles"])
    return await identity_response(session, user)


async def complete_onboarding(
    session: AsyncSession, user: User, request: CompleteOnboardingRequest
) -> IdentityResponse:
    if request.role not in {RoleName.PLAYER, RoleName.RECRUITER}:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={"code": "unsupported_onboarding_role", "message": "Choose player or scout."},
        )

    existing_roles = {assignment.role for assignment in user.roles}
    validate_role_selection(existing_roles, request.role)

    username_owner = await session.scalar(
        select(User).where(User.username == request.username, User.id != user.id)
    )
    if username_owner is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "username_taken", "message": "That username is already taken."},
        )

    user.full_name = request.full_name
    user.username = request.username
    if request.avatar_object_path is not None and not request.avatar_object_path.startswith(
        f"{user.id}/"
    ):
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={
                "code": "invalid_avatar_path",
                "message": "The profile photo does not belong to this account.",
            },
        )
    user.avatar_object_path = request.avatar_object_path

    if request.role == RoleName.PLAYER:
        if request.birth_date is None or request.position is None:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail={
                    "code": "player_details_required",
                    "message": "Player date of birth and position are required.",
                },
            )
        player_age = age_on(request.birth_date, date.today())
        if player_age < 6 or player_age > 23:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail={
                    "code": "player_age_out_of_range",
                    "message": "Player profiles are currently available for ages 6-23.",
                },
            )
        player = await session.scalar(select(Player).where(Player.account_user_id == user.id))
        if player is None:
            player = Player(
                account_user_id=user.id,
                created_by_user_id=user.id,
                birth_date=request.birth_date,
            )
            session.add(player)
        player.birth_date = request.birth_date
        player.position = request.position
        player.preferred_foot = request.preferred_foot
    else:
        if request.country is None:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail={
                    "code": "scout_country_required",
                    "message": "Scout country is required.",
                },
            )
        recruiter = await session.get(RecruiterProfile, user.id)
        if recruiter is None:
            recruiter = RecruiterProfile(user_id=user.id)
            session.add(recruiter)
        recruiter.country = request.country
        recruiter.organization_name = request.organization_name

    if request.role not in existing_roles:
        session.add(UserRole(user_id=user.id, role=request.role))
    user.onboarding_completed_at = datetime.now(UTC)
    try:
        await session.commit()
    except IntegrityError as error:
        await session.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail={"code": "username_taken", "message": "That username is already taken."},
        ) from error
    await session.refresh(user, attribute_names=["roles"])
    return await identity_response(session, user)


async def create_guardian_player(
    session: AsyncSession, user: User, request: GuardianPlayerCreate
) -> tuple[Player, GuardianRelationship]:
    if RoleName.GUARDIAN not in {assignment.role for assignment in user.roles}:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"code": "guardian_role_required", "message": "Guardian role is required."},
        )
    player_age = age_on(request.birth_date, date.today())
    if player_age < 6 or player_age >= 18:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail={
                "code": "minor_age_required",
                "message": "Guardian onboarding is available for players aged 6-17.",
            },
        )
    player = Player(created_by_user_id=user.id, birth_date=request.birth_date)
    session.add(player)
    await session.flush()
    relationship = GuardianRelationship(
        guardian_user_id=user.id,
        player_id=player.id,
        relationship_type=request.relationship_type.strip().lower(),
    )
    session.add(relationship)
    session.add(
        ConsentRecord(
            user_id=user.id,
            player_id=player.id,
            consent_type="guardian_onboarding",
            document_version=request.consent_version,
        )
    )
    await session.commit()
    await session.refresh(player)
    await session.refresh(relationship)
    return player, relationship
