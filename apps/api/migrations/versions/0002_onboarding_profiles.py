"""Add player and scout onboarding profile fields.

Revision ID: 0002_onboarding_profiles
Revises: 0001_identity
Create Date: 2026-10-31
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0002_onboarding_profiles"
down_revision: str | None = "0001_identity"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None
APP_SCHEMA = "app"


def upgrade() -> None:
    op.add_column("users", sa.Column("full_name", sa.String(length=120)), schema=APP_SCHEMA)
    op.add_column("users", sa.Column("username", sa.String(length=24)), schema=APP_SCHEMA)
    op.add_column(
        "users", sa.Column("avatar_object_path", sa.String(length=500)), schema=APP_SCHEMA
    )
    op.add_column(
        "users", sa.Column("onboarding_completed_at", sa.DateTime(timezone=True)), schema=APP_SCHEMA
    )
    op.create_index(
        op.f("ix_users_username"), "users", ["username"], unique=True, schema=APP_SCHEMA
    )
    op.create_check_constraint(
        "ck_users_username_format",
        "users",
        "username IS NULL OR username ~ '^[a-z0-9_]{3,24}$'",
        schema=APP_SCHEMA,
    )

    op.add_column("players", sa.Column("position", sa.String(length=40)), schema=APP_SCHEMA)
    op.add_column("players", sa.Column("preferred_foot", sa.String(length=10)), schema=APP_SCHEMA)
    op.add_column(
        "recruiter_profiles", sa.Column("country", sa.String(length=80)), schema=APP_SCHEMA
    )
    op.add_column(
        "recruiter_profiles",
        sa.Column("organization_name", sa.String(length=160)),
        schema=APP_SCHEMA,
    )
    op.execute("UPDATE app.user_roles SET role = 'player' WHERE role = 'adult_player'")


def downgrade() -> None:
    op.execute("UPDATE app.user_roles SET role = 'adult_player' WHERE role = 'player'")
    op.drop_column("recruiter_profiles", "organization_name", schema=APP_SCHEMA)
    op.drop_column("recruiter_profiles", "country", schema=APP_SCHEMA)
    op.drop_column("players", "preferred_foot", schema=APP_SCHEMA)
    op.drop_column("players", "position", schema=APP_SCHEMA)
    op.drop_constraint("ck_users_username_format", "users", schema=APP_SCHEMA)
    op.drop_index(op.f("ix_users_username"), table_name="users", schema=APP_SCHEMA)
    op.drop_column("users", "onboarding_completed_at", schema=APP_SCHEMA)
    op.drop_column("users", "avatar_object_path", schema=APP_SCHEMA)
    op.drop_column("users", "username", schema=APP_SCHEMA)
    op.drop_column("users", "full_name", schema=APP_SCHEMA)
