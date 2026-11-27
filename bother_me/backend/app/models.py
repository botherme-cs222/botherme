"""SQLModel classes.

`table=True` classes mirror the tables in schema.sql (schema.sql is the source of truth;
we never call create_all). The other classes are request/response shapes for the API.
"""
from datetime import datetime, timezone
from typing import Literal, Optional

from sqlmodel import Field, SQLModel

Status = Literal["irl", "online", "anywhere", "dnd"]


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


# ---------- Tables ----------

class User(SQLModel, table=True):
    __tablename__ = "users"
    id: Optional[int] = Field(default=None, primary_key=True)
    firebase_uid: str
    username: str
    full_name: Optional[str] = None
    email: str
    status: str = "anywhere"
    created_at: datetime = Field(default_factory=utcnow)


class Friendship(SQLModel, table=True):
    __tablename__ = "friendships"
    requester_id: int = Field(primary_key=True, foreign_key="users.id")
    addressee_id: int = Field(primary_key=True, foreign_key="users.id")
    accepted: bool = False
    created_at: datetime = Field(default_factory=utcnow)


class Group(SQLModel, table=True):
    __tablename__ = "groups"
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    owner_id: int = Field(foreign_key="users.id")
    icon: Optional[str] = None
    color: Optional[str] = None
    created_at: datetime = Field(default_factory=utcnow)


class GroupMember(SQLModel, table=True):
    __tablename__ = "group_members"
    group_id: int = Field(primary_key=True, foreign_key="groups.id")
    user_id: int = Field(primary_key=True, foreign_key="users.id")


class Bother(SQLModel, table=True):
    __tablename__ = "bothers"
    id: Optional[int] = Field(default=None, primary_key=True)
    sender_id: int = Field(foreign_key="users.id")
    group_id: Optional[int] = Field(default=None, foreign_key="groups.id")
    message: str
    scheduled_at: Optional[datetime] = None
    created_at: datetime = Field(default_factory=utcnow)


class BotherRecipient(SQLModel, table=True):
    __tablename__ = "bother_recipients"
    bother_id: int = Field(primary_key=True, foreign_key="bothers.id")
    recipient_id: int = Field(primary_key=True, foreign_key="users.id")
    read_at: Optional[datetime] = None


class Message(SQLModel, table=True):
    __tablename__ = "messages"
    id: Optional[int] = Field(default=None, primary_key=True)
    sender_id: int = Field(foreign_key="users.id")
    recipient_id: int = Field(foreign_key="users.id")
    body: str
    created_at: datetime = Field(default_factory=utcnow)


# ---------- API request/response shapes ----------

class UserPublic(SQLModel):
    id: int
    username: str
    full_name: Optional[str]
    status: str


class UserCreate(SQLModel):
    username: str
    full_name: Optional[str] = None


class UserUpdate(SQLModel):
    full_name: Optional[str] = None
    status: Optional[Status] = None


# Add request/response shapes for your feature below (e.g. FriendOut, BotherCreate).
