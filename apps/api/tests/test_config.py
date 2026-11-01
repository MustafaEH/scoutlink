import pytest
from pydantic import ValidationError
from scoutlink_api.core.config import Settings


def test_production_rejects_local_or_missing_configuration() -> None:
    with pytest.raises(ValidationError) as error:
        Settings(_env_file=None, environment="production")

    assert "SCOUTLINK_DATABASE_URL" in str(error.value)
    assert "SCOUTLINK_SUPABASE_JWKS_URL" in str(error.value)


def test_staging_can_use_explicit_auth_configuration() -> None:
    settings = Settings(
        _env_file=None,
        environment="staging",
        supabase_url="https://example.supabase.co",
        supabase_jwt_issuer="https://example.supabase.co/auth/v1",
        supabase_jwks_url="https://example.supabase.co/auth/v1/.well-known/jwks.json",
    )

    assert settings.docs_enabled
