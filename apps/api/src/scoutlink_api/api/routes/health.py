from typing import Literal

from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
from sqlalchemy import text

from scoutlink_api.db.session import session_factory

router = APIRouter()


class HealthResponse(BaseModel):
    status: Literal["ok"] = "ok"
    service: str = "scoutlink-api"


@router.get("/live", response_model=HealthResponse)
async def liveness() -> HealthResponse:
    return HealthResponse()


@router.get("/ready", response_model=HealthResponse)
async def readiness() -> HealthResponse:
    try:
        async with session_factory() as session:
            await session.execute(text("SELECT 1"))
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={"code": "database_unavailable", "message": "Database is unavailable."},
        ) from exc
    return HealthResponse()
