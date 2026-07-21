"""Health check endpoint for the AI Gateway."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/health")
async def health_check():
    return {
        "status": "ok",
        "service": "ai-gateway",
        "version": "0.1.0",
        "timestamp": None,  # will be set by middleware
    }
