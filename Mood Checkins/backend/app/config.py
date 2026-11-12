from pydantic_settings import BaseSettings, SettingsConfigDict
from supabase import create_client, Client


class Settings(BaseSettings):
    supabase_url: str
    supabase_service_key: str
    model_config = SettingsConfigDict(env_file=".env")


settings = Settings()
supabase: Client = create_client(settings.supabase_url, settings.supabase_service_key)
