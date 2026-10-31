"""Create identity, role, recruiter, guardian, and consent foundations.

Revision ID: 0001_identity
Revises:
Create Date: 2026-10-30
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0001_identity"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None
APP_SCHEMA = "app"


def upgrade() -> None:
    # Alembic creates this bookkeeping table in public before running the first
    # migration. It contains no product data, but Supabase exposes public by
    # default, so keep it inaccessible to Data API roles as defense in depth.
    op.execute("ALTER TABLE public.alembic_version ENABLE ROW LEVEL SECURITY")
    op.execute(sa.schema.CreateSchema(APP_SCHEMA, if_not_exists=True))

    op.create_table(
        "users",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("email", sa.String(length=320), nullable=False),
        sa.Column("status", sa.String(length=32), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_users")),
        sa.UniqueConstraint("email", name=op.f("uq_users_email")),
        schema=APP_SCHEMA,
    )
    op.create_index(op.f("ix_users_email"), "users", ["email"], schema=APP_SCHEMA)

    op.create_table(
        "user_roles",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("role", sa.String(length=40), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            [f"{APP_SCHEMA}.users.id"],
            name=op.f("fk_user_roles_user_id_users"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_user_roles")),
        sa.UniqueConstraint("user_id", "role", name=op.f("uq_user_roles_user_id")),
        schema=APP_SCHEMA,
    )
    op.create_index(op.f("ix_user_roles_user_id"), "user_roles", ["user_id"], schema=APP_SCHEMA)

    op.create_table(
        "recruiter_profiles",
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("verification_status", sa.String(length=32), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            [f"{APP_SCHEMA}.users.id"],
            name=op.f("fk_recruiter_profiles_user_id_users"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("user_id", name=op.f("pk_recruiter_profiles")),
        schema=APP_SCHEMA,
    )

    op.create_table(
        "players",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("account_user_id", sa.Uuid(), nullable=True),
        sa.Column("created_by_user_id", sa.Uuid(), nullable=False),
        sa.Column("birth_date", sa.Date(), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["account_user_id"],
            [f"{APP_SCHEMA}.users.id"],
            name=op.f("fk_players_account_user_id_users"),
            ondelete="SET NULL",
        ),
        sa.ForeignKeyConstraint(
            ["created_by_user_id"],
            [f"{APP_SCHEMA}.users.id"],
            name=op.f("fk_players_created_by_user_id_users"),
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_players")),
        sa.UniqueConstraint("account_user_id", name=op.f("uq_players_account_user_id")),
        schema=APP_SCHEMA,
    )
    op.create_index(
        op.f("ix_players_created_by_user_id"),
        "players",
        ["created_by_user_id"],
        schema=APP_SCHEMA,
    )

    op.create_table(
        "guardian_relationships",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("guardian_user_id", sa.Uuid(), nullable=False),
        sa.Column("player_id", sa.Uuid(), nullable=False),
        sa.Column("relationship_type", sa.String(length=50), nullable=False),
        sa.Column("status", sa.String(length=32), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["guardian_user_id"],
            [f"{APP_SCHEMA}.users.id"],
            name=op.f("fk_guardian_relationships_guardian_user_id_users"),
        ),
        sa.ForeignKeyConstraint(
            ["player_id"],
            [f"{APP_SCHEMA}.players.id"],
            name=op.f("fk_guardian_relationships_player_id_players"),
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_guardian_relationships")),
        sa.UniqueConstraint(
            "guardian_user_id", "player_id", name=op.f("uq_guardian_relationships_guardian_user_id")
        ),
        schema=APP_SCHEMA,
    )
    op.create_index(
        op.f("ix_guardian_relationships_guardian_user_id"),
        "guardian_relationships",
        ["guardian_user_id"],
        schema=APP_SCHEMA,
    )
    op.create_index(
        op.f("ix_guardian_relationships_player_id"),
        "guardian_relationships",
        ["player_id"],
        schema=APP_SCHEMA,
    )

    op.create_table(
        "consent_records",
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column("player_id", sa.Uuid(), nullable=True),
        sa.Column("consent_type", sa.String(length=60), nullable=False),
        sa.Column("document_version", sa.String(length=30), nullable=False),
        sa.Column(
            "granted_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column("withdrawn_at", sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(
            ["player_id"],
            [f"{APP_SCHEMA}.players.id"],
            name=op.f("fk_consent_records_player_id_players"),
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            [f"{APP_SCHEMA}.users.id"],
            name=op.f("fk_consent_records_user_id_users"),
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_consent_records")),
        schema=APP_SCHEMA,
    )
    op.create_index(
        op.f("ix_consent_records_player_id"),
        "consent_records",
        ["player_id"],
        schema=APP_SCHEMA,
    )
    op.create_index(
        op.f("ix_consent_records_user_id"),
        "consent_records",
        ["user_id"],
        schema=APP_SCHEMA,
    )


def downgrade() -> None:
    op.drop_table("consent_records", schema=APP_SCHEMA)
    op.drop_table("guardian_relationships", schema=APP_SCHEMA)
    op.drop_table("players", schema=APP_SCHEMA)
    op.drop_table("recruiter_profiles", schema=APP_SCHEMA)
    op.drop_table("user_roles", schema=APP_SCHEMA)
    op.drop_table("users", schema=APP_SCHEMA)
    op.execute(sa.schema.DropSchema(APP_SCHEMA))
