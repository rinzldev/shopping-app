from fastapi import APIRouter, HTTPException, status

from app.core.dependencies import CurrentUserId, DbSession
from app.schemas.price import PriceCreate, PriceRead
from app.services import price_service

router = APIRouter(prefix="/products/{product_id}/prices", tags=["prices"])


@router.get("", response_model=list[PriceRead])
def list_prices(
    product_id: int, db: DbSession, user_id: CurrentUserId
) -> list[PriceRead]:
    prices = price_service.list_prices(db, user_id, product_id)
    if prices is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Product not found"
        )
    return prices


@router.post("", response_model=PriceRead, status_code=status.HTTP_201_CREATED)
def add_price(
    product_id: int, payload: PriceCreate, db: DbSession, user_id: CurrentUserId
) -> PriceRead:
    price = price_service.add_price(db, user_id, product_id, payload)
    if price is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Product not found"
        )
    return price
