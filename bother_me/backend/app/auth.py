"""Authentication: the Flutter app signs in with Firebase, then sends the Firebase ID
token as `Authorization: Bearer <token>`. We verify it here; no passwords live in our DB.
"""
import firebase_admin
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth as firebase_auth
from sqlmodel import Session, select

from .config import settings
from .db import get_session
from .models import User

# Verifying ID tokens only needs the (public) project ID, no service-account key.
firebase_admin.initialize_app(options={"projectId": settings.firebase_project_id})

bearer = HTTPBearer()


def get_firebase_claims(creds: HTTPAuthorizationCredentials = Depends(bearer)) -> dict:
    """Returns the verified token claims ({"uid": ..., "email": ...})."""
    token = creds.credentials

    # Local testing shortcut: "dev:<firebase_uid>" (e.g. dev:seed-alice)
    if settings.dev_auth and token.startswith("dev:"):
        uid = token[4:]
        return {"uid": uid, "email": f"{uid}@dev.local"}

    try:
        return firebase_auth.verify_id_token(token)
    except Exception:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid or expired Firebase token")


def get_current_user(
    claims: dict = Depends(get_firebase_claims),
    session: Session = Depends(get_session),
) -> User:
    """The signed-in user's row. 404 if they haven't called POST /users/me yet."""
    user = session.exec(select(User).where(User.firebase_uid == claims["uid"])).first()
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "User not registered; call POST /users/me first")
    return user
