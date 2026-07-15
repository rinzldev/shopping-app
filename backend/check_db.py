from sqlalchemy import text

from app.core.database import engine

with engine.connect() as conn:
    version = conn.execute(text("SELECT version();")).scalar()
    tables = conn.execute(
        text(
            "SELECT tablename FROM pg_tables "
            "WHERE schemaname = 'public' ORDER BY tablename;"
        )
    ).scalars().all()

print("Conexión OK")
print("Postgres:", version)
print("Tablas:", tables)
