from datetime import date

import pytest
from fastapi import HTTPException
from scoutlink_api.modules.identity.models import RoleName
from scoutlink_api.modules.identity.service import (
    SELF_ASSIGNABLE_ROLES,
    age_on,
    validate_role_selection,
)


@pytest.mark.parametrize(
    ("birth_date", "on_date", "expected"),
    [
        (date(2010, 10, 31), date(2026, 10, 30), 15),
        (date(2010, 10, 31), date(2026, 10, 31), 16),
        (date(2008, 2, 29), date(2026, 2, 28), 17),
    ],
)
def test_age_on_handles_birthdays(birth_date: date, on_date: date, expected: int) -> None:
    assert age_on(birth_date, on_date) == expected


def test_staff_roles_cannot_be_self_assigned() -> None:
    assert RoleName.ADMINISTRATOR not in SELF_ASSIGNABLE_ROLES
    assert RoleName.OPERATOR not in SELF_ASSIGNABLE_ROLES
    assert RoleName.SAFEGUARDING_ADMIN not in SELF_ASSIGNABLE_ROLES


def test_role_cannot_be_changed_without_support() -> None:
    with pytest.raises(HTTPException) as error:
        validate_role_selection({RoleName.GUARDIAN}, RoleName.RECRUITER)

    assert error.value.status_code == 409


def test_staff_role_selection_is_forbidden() -> None:
    with pytest.raises(HTTPException) as error:
        validate_role_selection(set(), RoleName.ADMINISTRATOR)

    assert error.value.status_code == 403


def test_identity_routes_are_protected_in_openapi() -> None:
    from scoutlink_api.main import app

    schema = app.openapi()
    operation = schema["paths"]["/api/v1/identity/me"]["get"]
    assert operation["security"] == [{"HTTPBearer": []}]
