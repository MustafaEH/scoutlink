from datetime import date

from fastapi import HTTPException, status
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
from scoutlink_api.modules.identity.schemas import GuardianPlayerCreate, IdentityResponse

SELF_ASSIGNABLE_ROLES = {
    RoleName.ADULT_PLAYER,
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
