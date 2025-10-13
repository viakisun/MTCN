from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class ScoreBase(BaseModel):
    player_id: str
    rounding_id: str
    total_score: int
    par: int = 72
    birdies: int = 0
    pars: int = 0
    bogeys: int = 0
    hole_scores: list[int]  # 18홀 스코어


class ScoreCreate(ScoreBase):
    pass


class ScoreUpdate(BaseModel):
    total_score: Optional[int] = None
    hole_scores: Optional[list[int]] = None


class ScoreResponse(ScoreBase):
    id: str
    player_name: str
    course_name: str
    date: datetime
    created_at: datetime

    class Config:
        from_attributes = True


class ScoreList(BaseModel):
    total: int
    items: list[ScoreResponse]
