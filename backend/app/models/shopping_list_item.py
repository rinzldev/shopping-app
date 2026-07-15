from datetime import datetime
from decimal import Decimal

from sqlalchemy import BigInteger, Boolean, CheckConstraint, DateTime, ForeignKey, Index, Numeric, func, text

from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class ShoppingListItem(Base):
    __tablename__ = "shopping_list_items"
    __table_args__ = (
        CheckConstraint(
            "quantity_needed > 0", name="ck_shopping_list_quantity_positive"
        ),
        Index(
         "uq_shopping_list_active_item",
            "user_id",
            "product_id",
            unique=True,
            postgresql_where=text("is_purchased = false"),
       ),
    )

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    product_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("products.id", ondelete="CASCADE"), index=True
    )
    quantity_needed: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    estimated_unit_cost: Mapped[Decimal | None] = mapped_column(Numeric(10, 2))
    is_purchased: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    user: Mapped["User"] = relationship(back_populates="shopping_list_items")
    product: Mapped["Product"] = relationship()
