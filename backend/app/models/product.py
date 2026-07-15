from datetime import datetime

from sqlalchemy import BigInteger, CheckConstraint, DateTime, ForeignKey, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base

VALID_UNITS = ("unit", "kg", "g", "l", "ml", "pack")


class Product(Base):
    __tablename__ = "products"
    __table_args__ = (
        CheckConstraint(
            f"unit_of_measure IN {VALID_UNITS}", name="ck_products_unit_of_measure"
        ),
    )

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    category_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("categories.id", ondelete="SET NULL"), index=True
    )
    name: Mapped[str] = mapped_column(String(255))
    brand: Mapped[str | None] = mapped_column(String(255))
    unit_of_measure: Mapped[str] = mapped_column(String(20))
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    owner: Mapped["User"] = relationship(back_populates="products")
    category: Mapped["Category | None"] = relationship(back_populates="products")
    inventory: Mapped["Inventory | None"] = relationship(
        back_populates="product", cascade="all, delete-orphan", uselist=False
    )
    price_history: Mapped[list["PriceHistory"]] = relationship(
        back_populates="product", cascade="all, delete-orphan"
    )
