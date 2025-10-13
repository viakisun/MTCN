from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime


class PlayerBase(BaseModel):
    name: str
    email: EmailStr
    phone: Optional[str] = None
    handicap: int = 0
    avatar_url: Optional[str] = None


class PlayerCreate(PlayerBase):
    password: str


class PlayerUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    handicap: Optional[int] = None
    avatar_url: Optional[str] = None


class PlayerResponse(PlayerBase):
    id: str
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class PlayerList(BaseModel):
    total: int
    items: list[PlayerResponse]
