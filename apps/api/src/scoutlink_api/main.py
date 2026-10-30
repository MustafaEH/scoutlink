from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from scoutlink_api.api.router import api_router
from scoutlink_api.core.config import get_settings


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[None]:
    yield


settings = get_settings()
app = FastAPI(
    title="ScoutLink API",
    version="0.1.0",
    docs_url="/docs" if settings.docs_enabled else None,
    redoc_url=None,
    openapi_url="/openapi.json" if settings.docs_enabled else None,
    lifespan=lifespan,
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[str(origin) for origin in settings.cors_origins],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type", "Idempotency-Key"],
)
app.include_router(api_router, prefix="/api/v1")
