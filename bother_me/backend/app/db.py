from sqlmodel import Session, create_engine

from .config import settings

engine = create_engine(settings.database_url, pool_pre_ping=True)


def get_session():
    """FastAPI dependency: one DB session per request."""
    with Session(engine) as session:
        yield session
