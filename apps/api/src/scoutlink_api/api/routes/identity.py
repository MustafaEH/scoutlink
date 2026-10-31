from typing import Annotated

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from scoutlink_api.core.auth import Principal, require_principal
from scoutlink_api.db.session import get_session
from scoutlink_api.modules.identity.schemas import (
    GuardianPlayerCreate,
    GuardianPlayerResponse,
    IdentityResponse,
    SelectRoleRequest,
)
from scoutlink_api.modules.identity.service import (
    create_guardian_player,
    get_or_create_user,
    identity_response,
    select_role,
)

router = APIRouter()
PrincipalDependency = Annotated[Principal, Depends(require_principal)]
SessionDependency = Annotated[AsyncSession, Depends(get_session)]


@router.get("/me", response_model=IdentityResponse)
async def get_me(
    principal: PrincipalDependency,
    session: SessionDependency,
) -> IdentityResponse:
    user = await get_or_create_user(session, principal)
    await session.commit()
    return await identity_response(session, user)


@router.post("/roles", response_model=IdentityResponse)
async def choose_role(
    request: SelectRoleRequest,
    principal: PrincipalDependency,
    session: SessionDependency,
) -> IdentityResponse:
    user = await get_or_create_user(session, principal)
    return await select_role(session, user, request.role)


@router.post(
    "/guardian-players",
    response_model=GuardianPlayerResponse,
    status_code=status.HTTP_201_CREATED,
)
async def add_guardian_player(
    request: GuardianPlayerCreate,
    principal: PrincipalDependency,
    session: SessionDependency,
) -> GuardianPlayerResponse:
    user = await get_or_create_user(session, principal)
    player, relationship = await create_guardian_player(session, user, request)
    return GuardianPlayerResponse(
        player_id=player.id,
        relationship_id=relationship.id,
        relationship_status=relationship.status,
        birth_date=player.birth_date,
        created_at=relationship.created_at,
    )
