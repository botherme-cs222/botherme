from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    database_url: str = "postgresql+psycopg://botherme:botherme@localhost:5433/botherme"
    firebase_project_id: str = "botherme-1f44f"
    dev_auth: bool = False

    model_config = SettingsConfigDict(env_file=".env")


settings = Settings()
