from datetime import date, datetime
from enum import StrEnum
from uuid import UUID, uuid4

from sqlalchemy import Date, DateTime, Enum, ForeignKey, String, UniqueConstraint, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from scoutlink_api.db.base import APP_SCHEMA, Base


def app_foreign_key(target: str, *, ondelete: str | None = None) -> ForeignKey:
    return ForeignKey(f"{APP_SCHEMA}.{target}", ondelete=ondelete)


class UserStatus(StrEnum):
    ACTIVE = "active"
    SUSPENDED = "suspended"
    CLOSED = "closed"


class RoleName(StrEnum):
    ADULT_PLAYER = "adult_player"
    GUARDIAN = "guardian"
    RECRUITER = "recruiter"
    ACADEMY_REPRESENTATIVE = "academy_representative"
    OPERATOR = "operator"
    SAFEGUARDING_ADMIN = "safeguarding_admin"
    ADMINISTRATOR = "administrator"


class VerificationStatus(StrEnum):
    PENDING = "pending"
    IN_REVIEW = "in_review"
    VERIFIED = "verified"
    CHANGES_REQUESTED = "changes_requested"
    REJECTED = "rejected"
    SUSPENDED = "suspended"


class RelationshipStatus(StrEnum):
    PENDING = "pending"
    VERIFIED = "verified"
    CHANGES_REQUESTED = "changes_requested"
    DISPUTED = "disputed"
    REVOKED = "revoked"


class User(Base):
    __tablename__ = "users"

    id: Mapped[UUID] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(320), unique=True, index=True)
    status: Mapped[UserStatus] = mapped_column(
        Enum(UserStatus, native_enum=False, length=32), default=UserStatus.ACTIVE
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )
    roles: Mapped[list["UserRole"]] = relationship(cascade="all, delete-orphan")


class UserRole(Base):
    __tablename__ = "user_roles"
    __table_args__ = (UniqueConstraint("user_id", "role"),)

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    user_id: Mapped[UUID] = mapped_column(
        app_foreign_key("users.id", ondelete="CASCADE"), index=True
    )
    role: Mapped[RoleName] = mapped_column(Enum(RoleName, native_enum=False, length=40))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class RecruiterProfile(Base):
    __tablename__ = "recruiter_profiles"

    user_id: Mapped[UUID] = mapped_column(
        app_foreign_key("users.id", ondelete="CASCADE"), primary_key=True
    )
    verification_status: Mapped[VerificationStatus] = mapped_column(
        Enum(VerificationStatus, native_enum=False, length=32),
        default=VerificationStatus.PENDING,
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class Player(Base):
    __tablename__ = "players"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    account_user_id: Mapped[UUID | None] = mapped_column(
        app_foreign_key("users.id", ondelete="SET NULL"), unique=True
    )
    created_by_user_id: Mapped[UUID] = mapped_column(app_foreign_key("users.id"), index=True)
    birth_date: Mapped[date] = mapped_column(Date)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class GuardianRelationship(Base):
    __tablename__ = "guardian_relationships"
    __table_args__ = (UniqueConstraint("guardian_user_id", "player_id"),)

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    guardian_user_id: Mapped[UUID] = mapped_column(app_foreign_key("users.id"), index=True)
    player_id: Mapped[UUID] = mapped_column(app_foreign_key("players.id"), index=True)
    relationship_type: Mapped[str] = mapped_column(String(50))
    status: Mapped[RelationshipStatus] = mapped_column(
        Enum(RelationshipStatus, native_enum=False, length=32),
        default=RelationshipStatus.PENDING,
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class ConsentRecord(Base):
    __tablename__ = "consent_records"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    user_id: Mapped[UUID] = mapped_column(app_foreign_key("users.id"), index=True)
    player_id: Mapped[UUID | None] = mapped_column(app_foreign_key("players.id"), index=True)
    consent_type: Mapped[str] = mapped_column(String(60))
    document_version: Mapped[str] = mapped_column(String(30))
    granted_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    withdrawn_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
