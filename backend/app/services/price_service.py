from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models import PriceHistory
from app.schemas.price import PriceCreate
from app.services import product_service


def list_prices(db: Session, user_id: int, product_id: int) -> list[PriceHistory] | None:
    # Primero verifica que el producto exista y sea del usuario.
    product = product_service.get_product(db, user_id, product_id)
    if product is None:
        return None
    stmt = (
        select(PriceHistory)
        .where(PriceHistory.product_id == product_id)
        .order_by(PriceHistory.recorded_at.desc())
    )
    return list(db.scalars(stmt).all())


def add_price(
    db: Session, user_id: int, product_id: int, data: PriceCreate
) -> PriceHistory | None:
    product = product_service.get_product(db, user_id, product_id)
    if product is None:
        return None
    price = PriceHistory(product_id=product_id, **data.model_dump())
    db.add(price)
    db.commit()
    db.refresh(price)
    return price
