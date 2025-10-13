from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum


class RoundingStatus(str, Enum):
    SCHEDULED = "scheduled"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class RoundingBase(BaseModel):
    event_name: str
    course_name: str
    date: str
    tee_time: str
    status: RoundingStatus = RoundingStatus.SCHEDULED


class RoundingCreate(RoundingBase):
    group_id: str
    player_ids: list[str]


class RoundingResponse(RoundingBase):
    id: str
    group_id: str
    group_name: str
    player_count: int
    created_at: datetime

    class Config:
        from_attributes = True


class RoundingList(BaseModel):
    total: int
    items: list[RoundingResponse]
