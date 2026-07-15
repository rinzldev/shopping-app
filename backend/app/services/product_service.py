from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models import Product
from app.schemas.product import ProductCreate, ProductUpdate


def list_products(db: Session, user_id: int) -> list[Product]:
    stmt = select(Product).where(Product.user_id == user_id).order_by(Product.name)
    return list(db.scalars(stmt).all())


def get_product(db: Session, user_id: int, product_id: int) -> Product | None:
    stmt = select(Product).where(
        Product.id == product_id, Product.user_id == user_id
    )
    return db.scalars(stmt).first()


def create_product(db: Session, user_id: int, data: ProductCreate) -> Product:
    product = Product(user_id=user_id, **data.model_dump())
    db.add(product)
    db.commit()
    db.refresh(product)
    return product


def update_product(
    db: Session, user_id: int, product_id: int, data: ProductUpdate
) -> Product | None:
    product = get_product(db, user_id, product_id)
    if product is None:
        return None
    # exclude_unset: solo actualiza los campos que el cliente realmente envió.
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(product, field, value)
    db.commit()
    db.refresh(product)
    return product
