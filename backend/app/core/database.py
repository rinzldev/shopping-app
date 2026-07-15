from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.core.config import get_settings

settings = get_settings()

# El engine es el pool de conexiones a Postgres. Se crea UNA vez por proceso.
engine = create_engine(
    settings.database_url,
    pool_pre_ping=True,  # verifica que la conexión siga viva antes de usarla
    echo=False,          # ponlo en True si quieres ver el SQL generado en consola
)

# Fábrica de sesiones. Cada request HTTP usará su propia Session.
SessionLocal = sessionmaker(
    bind=engine,
    autocommit=False,
    autoflush=False,
)


class Base(DeclarativeBase):
    """Clase base de la que heredarán todos los modelos ORM."""


def get_db() -> Generator[Session, None, None]:
    """Dependencia de FastAPI: abre una Session por request y la cierra al final."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
