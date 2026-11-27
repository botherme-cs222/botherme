from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select

from ..auth import get_current_user, get_firebase_claims
from ..db import get_session
from ..models import User, UserCreate, UserPublic, UserUpdate

router = APIRouter(prefix="/users", tags=["users"])


@router.post("/me", response_model=User, status_code=201)
def register_me(
    body: UserCreate,
    claims: dict = Depends(get_firebase_claims),
    session: Session = Depends(get_session),
):
    """Create the DB row for a Firebase user. Call once right after Firebase sign-up."""
    if session.exec(select(User).where(User.firebase_uid == claims["uid"])).first():
        raise HTTPException(409, "Already registered")
    if session.exec(select(User).where(User.username == body.username)).first():
        raise HTTPException(409, "Username taken")

    user = User(
        firebase_uid=claims["uid"],
        email=claims.get("email", ""),
        username=body.username,
        full_name=body.full_name,
    )
    session.add(user)
    session.commit()
    session.refresh(user)
    return user


@router.get("/me", response_model=User)
def read_me(me: User = Depends(get_current_user)):
    return me


@router.patch("/me", response_model=User)
def update_me(
    body: UserUpdate,
    me: User = Depends(get_current_user),
    session: Session = Depends(get_session),
):
    """Update status ('irl' | 'online' | 'anywhere' | 'dnd') and/or full_name."""
    for key, value in body.model_dump(exclude_unset=True).items():
        setattr(me, key, value)
    session.add(me)
    session.commit()
    session.refresh(me)
    return me


@router.get("/search", response_model=list[UserPublic])
def search_users(
    q: str,
    me: User = Depends(get_current_user),
    session: Session = Depends(get_session),
):
    """Find users by username prefix (for the 'add friend' box)."""
    stmt = select(User).where(User.username.startswith(q), User.id != me.id).limit(20)
    return session.exec(stmt).all()
