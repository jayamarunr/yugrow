"""Chat and completion endpoints — the main AI interface."""

from fastapi import APIRouter

router = APIRouter()


@router.post("/chat")
async def chat_completion():
    """Send a chat completion request to the configured AI model.

    All Yugrow modules call this endpoint instead of calling AI providers directly.
    The AI Gateway handles: model routing, prompt management, token tracking,
    caching, fallback, and guardrails.
    """
    return {"message": "Not yet implemented"}


@router.post("/completion")
async def completion():
    """Send a text completion request."""
    return {"message": "Not yet implemented"}
