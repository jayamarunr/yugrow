# AI Gateway configuration

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Environment configuration for the AI Gateway."""

    # Service
    host: str = "0.0.0.0"
    port: int = 8000
    environment: str = "development"

    # Database
    database_url: str = "postgresql+psycopg2://yugrow:yugrow@localhost:5432/yugrow"

    # Redis
    redis_url: str = "redis://localhost:6379/0"

    # AI Providers
    openai_api_key: str = ""
    anthropic_api_key: str = ""
    deepseek_api_key: str = ""
    google_api_key: str = ""

    # Model Routing
    default_model: str = "gpt-4o-mini"
    fallback_model: str = "gpt-4o-mini"

    # Rate Limiting
    rate_limit_per_minute: int = 60

    class Config:
        env_file = ".env"


settings = Settings()
