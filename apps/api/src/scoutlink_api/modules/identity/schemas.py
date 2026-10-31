from datetime import date, datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field, field_validator

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
    full_name: str | None = None
    username: str | None = None
    onboarding_complete: bool = False
    status: UserStatus
    roles: list[RoleName]
    recruiter_verification: VerificationStatus | None = None


class SelectRoleRequest(BaseModel):
    role: RoleName


class CompleteOnboardingRequest(BaseModel):
    role: RoleName
    full_name: str = Field(min_length=2, max_length=120)
    username: str = Field(pattern=r"^[a-zA-Z0-9_]{3,24}$")
    birth_date: date | None = None
    position: str | None = Field(default=None, min_length=2, max_length=40)
    preferred_foot: str | None = Field(default=None, max_length=10)
    avatar_object_path: str | None = Field(default=None, max_length=500)
    country: str | None = Field(default=None, min_length=2, max_length=80)
    organization_name: str | None = Field(default=None, max_length=160)

    @field_validator("full_name", "position", "preferred_foot", "country", "organization_name")
    @classmethod
    def strip_text(cls, value: str | None) -> str | None:
        return value.strip() if value is not None else None

    @field_validator("username")
    @classmethod
    def normalize_username(cls, value: str) -> str:
        return value.strip().lower()


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
