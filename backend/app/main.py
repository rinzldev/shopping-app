from fastapi import FastAPI
from app.routers import prices, products

app = FastAPI(
    title = "Shopping App API",
    description="Gestión de inventario y gastos domésticos.",
    version="0.1.0",
)

@app.get("/health", tags=["meta"])
def health_check() -> dict[str, str]:
    """
    Comprueba que la API esta viva.
    """
    return {"status": "ok"}

app.include_router(products.router, prefix="/api/v1")
app.include_router(prices.router, prefix="/api/v1")