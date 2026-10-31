import asyncio
from dataclasses import dataclass
from functools import lru_cache
from typing import Annotated
from uuid import UUID

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from scoutlink_api.core.config import Settings, get_settings

bearer_scheme = HTTPBearer(auto_error=False)


@dataclass(frozen=True, slots=True)
class Principal:
    user_id: UUID
    email: str


class SupabaseTokenVerifier:
    def __init__(self, settings: Settings) -> None:
        self.settings = settings
        self.jwks_client = (
            jwt.PyJWKClient(settings.supabase_jwks_url) if settings.supabase_jwks_url else None
        )

    def _decode(self, token: str) -> dict[str, object]:
        if not self.jwks_client or not self.settings.supabase_jwt_issuer:
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail={"code": "auth_not_configured", "message": "Authentication is unavailable."},
            )
        signing_key = self.jwks_client.get_signing_key_from_jwt(token)
        return jwt.decode(
            token,
            signing_key.key,
            algorithms=["ES256", "RS256"],
            audience=self.settings.supabase_jwt_audience,
            issuer=self.settings.supabase_jwt_issuer,
        )

    async def verify(self, token: str) -> Principal:
        try:
            claims = await asyncio.to_thread(self._decode, token)
            subject = claims.get("sub")
            email = claims.get("email")
            if not isinstance(subject, str) or not isinstance(email, str):
                raise ValueError("Required claims are missing")
            return Principal(user_id=UUID(subject), email=email.lower())
        except HTTPException:
            raise
        except (ValueError, jwt.PyJWTError) as exc:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail={"code": "invalid_token", "message": "Authentication token is invalid."},
                headers={"WWW-Authenticate": "Bearer"},
            ) from exc


@lru_cache
def get_token_verifier() -> SupabaseTokenVerifier:
    return SupabaseTokenVerifier(get_settings())


async def require_principal(
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(bearer_scheme)],
    verifier: Annotated[SupabaseTokenVerifier, Depends(get_token_verifier)],
) -> Principal:
    if credentials is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"code": "authentication_required", "message": "Sign in is required."},
            headers={"WWW-Authenticate": "Bearer"},
        )
    return await verifier.verify(credentials.credentials)
