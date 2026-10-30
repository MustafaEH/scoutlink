from functools import lru_cache
from typing import Literal

from pydantic import AnyHttpUrl, Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_prefix="SCOUTLINK_", extra="ignore", case_sensitive=False
    )
    environment: Literal["local", "test", "staging", "production"] = "local"
    log_level: str = "INFO"
    database_url: str = "postgresql+psycopg://scoutlink:scoutlink@localhost:5432/scoutlink"
    cors_origins: list[AnyHttpUrl] = Field(
        default_factory=lambda: [
            AnyHttpUrl("http://localhost:3000"),
            AnyHttpUrl("http://localhost:8080"),
        ]
    )
    supabase_url: str | None = None
    supabase_jwt_issuer: str | None = None
    supabase_jwt_audience: str = "authenticated"
    mux_token_id: str | None = None
    mux_token_secret: str | None = None
    mux_webhook_secret: str | None = None

    @property
    def docs_enabled(self) -> bool:
        return self.environment != "production"


@lru_cache
def get_settings() -> Settings:
    return Settings()
