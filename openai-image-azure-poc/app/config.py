from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # -------------------------------------------------
    # Application
    # -------------------------------------------------
    APP_NAME: str = "OpenAI Image Azure POC"
    ENVIRONMENT: str = "dev"

    # -------------------------------------------------
    # Database
    # -------------------------------------------------
    DATABASE_URL: str

    # -------------------------------------------------
    # Azure
    # -------------------------------------------------
    AZURE_SUBSCRIPTION_ID: str
    AZURE_TENANT_ID: str
    AZURE_CLIENT_ID: str | None = None
    AZURE_CLIENT_SECRET: str | None = None

    AZURE_REGION: str = "Central India"

    # -------------------------------------------------
    # Azure Blob Storage
    # -------------------------------------------------
    AZURE_STORAGE_ACCOUNT_NAME: str
    AZURE_STORAGE_CONTAINER_NAME: str
    AZURE_STORAGE_CONNECTION_STRING: str

    BLOB_URL_EXPIRE_SECONDS: int = 3600

    # -------------------------------------------------
    # Azure Service Bus
    # -------------------------------------------------
    SERVICE_BUS_NAMESPACE: str
    SERVICE_BUS_QUEUE_NAME: str
    SERVICE_BUS_CONNECTION_STRING: str

    # -------------------------------------------------
    # Azure OpenAI
    # -------------------------------------------------
    AZURE_OPENAI_API_KEY: str
    AZURE_OPENAI_ENDPOINT: str
    AZURE_OPENAI_DEPLOYMENT_NAME: str
    AZURE_OPENAI_API_VERSION: str = "2025-01-01-preview"

    # -------------------------------------------------
    # Worker
    # -------------------------------------------------
    WORKER_POLL_SECONDS: int = 20
    WORKER_MAX_ATTEMPTS: int = 3

    # -------------------------------------------------
    # Security
    # -------------------------------------------------
    CORS_ORIGINS: str = "*"

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore",
    )


settings = Settings()
