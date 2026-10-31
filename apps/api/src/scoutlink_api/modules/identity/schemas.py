from datetime import date, datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

from scoutlink_api.modules.identity.models import (
    RelationshipStatus,
    RoleName,
    UserStatus,
    VerificationStatus,
)


class IdentityResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    email: str
    status: UserStatus
    roles: list[RoleName]
    recruiter_verification: VerificationStatus | None = None


class SelectRoleRequest(BaseModel):
    role: RoleName


class GuardianPlayerCreate(BaseModel):
    birth_date: date
    relationship_type: str = Field(min_length=2, max_length=50)
    consent_version: str = Field(min_length=1, max_length=30)


class GuardianPlayerResponse(BaseModel):
    player_id: UUID
    relationship_id: UUID
    relationship_status: RelationshipStatus
    birth_date: date
    created_at: datetime
