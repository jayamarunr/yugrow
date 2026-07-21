from fastapi import FastAPI
from datetime import datetime, timezone

app = FastAPI(
    title="Yugrow AI Gateway",
    version="0.1.0",
)


@app.get("/health")
def health():
    return {
        "status": "ok",
        "service": "yugrow-ai-gateway",
        "version": "0.1.0",
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }
