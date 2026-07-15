from typing import Annotated

from fastapi import Depends
from sqlalchemy.orm import Session

from app.core.database import get_db

DEV_USER_ID = 1


def get_current_user_id() -> int:
    """Stub temporal: devuelve el usuario de desarrollo.

    Se reemplazará por autenticación JWT real más adelante. Los routers
    dependen de ESTA función, no del id fijo, así que el cambio será local.
    """
    return DEV_USER_ID


# Alias tipados para inyectar en los endpoints sin repetir Depends(...) cada vez.
DbSession = Annotated[Session, Depends(get_db)]
CurrentUserId = Annotated[int, Depends(get_current_user_id)]
