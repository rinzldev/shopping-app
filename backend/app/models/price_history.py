from datetime import datetime
from decimal import Decimal

from sqlalchemy import BigInteger, CheckConstraint, DateTime, ForeignKey, Index, Numeric, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class PriceHistory(Base):
    __tablename__ = "price_history"
    __table_args__ = (
        CheckConstraint("unit_price >= 0", name="ck_price_history_price_non_negative"),
        Index("ix_price_history_product_recorded", "product_id", "recorded_at"),

    )

    id: Mapped[int] = mapped_column(primary_key=True)
    product_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("products.id", ondelete="CASCADE")
    )
    unit_price: Mapped[Decimal] = mapped_column(Numeric(10, 2))
    store: Mapped[str | None] = mapped_column(String(255))
    recorded_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    product: Mapped["Product"] = relationship(back_populates="price_history")
