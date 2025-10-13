from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class GroupBase(BaseModel):
    name: str
    description: Optional[str] = None
    avatar_url: Optional[str] = None
    is_public: bool = True


class GroupCreate(GroupBase):
    pass


class GroupUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    avatar_url: Optional[str] = None
    is_public: Optional[bool] = None


class GroupResponse(GroupBase):
    id: str
    member_count: int
    round_count: int
    created_at: datetime
    created_by: str

    class Config:
        from_attributes = True


class GroupList(BaseModel):
    total: int
    items: list[GroupResponse]
