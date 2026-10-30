from scoutlink_api.api.routes.health import HealthResponse
from scoutlink_api.main import app


def test_liveness() -> None:
    response = HealthResponse()
    assert response.model_dump() == {"status": "ok", "service": "scoutlink-api"}


def test_openapi_is_available_locally() -> None:
    schema = app.openapi()
    assert schema["info"]["title"] == "ScoutLink API"
    assert "/api/v1/health/live" in schema["paths"]
