from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Configuración de la app, cargada y validada desde variables de entorno."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    database_url: str


@lru_cache
def get_settings() -> Settings:
    """Devuelve una instancia única de Settings (cacheada)."""
    return Settings()
