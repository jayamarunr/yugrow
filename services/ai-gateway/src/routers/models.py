"""Model listing and selection endpoints."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/models")
async def list_models():
    """List available AI models and their status."""
    return {
        "models": [
            {"id": "gpt-4o", "provider": "openai", "status": "available"},
            {"id": "gpt-4o-mini", "provider": "openai", "status": "available"},
            {"id": "claude-3-opus", "provider": "anthropic", "status": "available"},
            {"id": "claude-3-sonnet", "provider": "anthropic", "status": "available"},
            {"id": "deepseek-chat", "provider": "deepseek", "status": "available"},
            {"id": "gemini-pro", "provider": "google", "status": "available"},
        ]
    }
