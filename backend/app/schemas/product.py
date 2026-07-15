from datetime import datetime
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field

UnitOfMeasure = Literal["unit", "kg", "g", "l", "ml", "pack"]


class ProductBase(BaseModel):
    name: str = Field(min_length=1, max_length=255)
    brand: str | None = Field(default=None, max_length=255)
    category_id: int | None = None
    unit_of_measure: UnitOfMeasure


class ProductCreate(ProductBase):
    """Lo que el cliente envía para crear. user_id NO viene del cliente:
    se toma del usuario autenticado, nunca del body (seguridad)."""


class ProductUpdate(BaseModel):
    """Todos los campos opcionales: permite actualizaciones parciales."""

    name: str | None = Field(default=None, min_length=1, max_length=255)
    brand: str | None = Field(default=None, max_length=255)
    category_id: int | None = None
    unit_of_measure: UnitOfMeasure | None = None


class ProductRead(ProductBase):
    """Lo que la API devuelve. from_attributes permite construirlo
    directo desde un objeto ORM."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime
    updated_at: datetime
