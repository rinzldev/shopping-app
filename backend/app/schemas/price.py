from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class PriceCreate(BaseModel):
    unit_price: Decimal = Field(gt=0, max_digits=10, decimal_places=2)
    store: str | None = Field(default=None, max_length=255)


class PriceRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    product_id: int
    unit_price: Decimal
    store: str | None
    recorded_at: datetime
