"""Token tracking and usage endpoints."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/tokens/usage")
async def get_token_usage():
    """Get token usage statistics for a tenant."""
    return {"total_tokens": 0, "by_model": {}, "by_date": {}}
