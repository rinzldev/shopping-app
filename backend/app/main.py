from fastapi import FastAPI
from app.routers import prices, products
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI(
    title = "Shopping App API",
    description="Gestión de inventario y gastos domésticos.",
    version="0.1.0",
)

# CORS: permite que el frontend web (otro origen) llame a la API.
# allow_origins=["*"] es SOLO para desarrollo; en producción se restringe.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health", tags=["meta"])
def health_check() -> dict[str, str]:
    """
    Comprueba que la API esta viva.
    """
    return {"status": "ok"}

app.include_router(products.router, prefix="/api/v1")
app.include_router(prices.router, prefix="/api/v1")