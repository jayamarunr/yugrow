"""
Yugrow AI Gateway — Unified AI service.

All Yugrow modules call this service for AI operations.
Never call OpenAI, Anthropic, etc. directly from business modules.
"""

from contextlib import asynccontextmanager
from typing import AsyncGenerator

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routers import chat, health, models, tokens


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """Startup and shutdown events."""
    # Startup: load config, init clients
    print("🔄 AI Gateway starting...")
    yield
    # Shutdown: cleanup clients
    print("🔄 AI Gateway shutting down...")


app = FastAPI(
    title="Yugrow AI Gateway",
    version="0.1.0",
    description="Unified AI service for the Yugrow Platform",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(health.router, prefix="/api/v1", tags=["health"])
app.include_router(models.router, prefix="/api/v1/ai", tags=["ai"])
app.include_router(chat.router, prefix="/api/v1/ai", tags=["ai"])
app.include_router(tokens.router, prefix="/api/v1/ai", tags=["ai"])


def start() -> None:
    """Entry point for `uv run yugrow-ai`."""
    import uvicorn

    uvicorn.run("src.main:app", host="0.0.0.0", port=8000, reload=True)
