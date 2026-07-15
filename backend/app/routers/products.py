from fastapi import APIRouter, HTTPException, status

from app.core.dependencies import CurrentUserId, DbSession
from app.schemas.product import ProductCreate, ProductRead, ProductUpdate
from app.services import product_service

router = APIRouter(prefix="/products", tags=["products"])


@router.get("", response_model=list[ProductRead])
def list_products(db: DbSession, user_id: CurrentUserId) -> list[ProductRead]:
    return product_service.list_products(db, user_id)


@router.post("", response_model=ProductRead, status_code=status.HTTP_201_CREATED)
def create_product(
    payload: ProductCreate, db: DbSession, user_id: CurrentUserId
) -> ProductRead:
    return product_service.create_product(db, user_id, payload)


@router.put("/{product_id}", response_model=ProductRead)
def update_product(
    product_id: int, payload: ProductUpdate, db: DbSession, user_id: CurrentUserId
) -> ProductRead:
    product = product_service.update_product(db, user_id, product_id, payload)
    if product is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Product not found"
        )
    return product
