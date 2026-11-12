from datetime import date
from typing import Optional
from pydantic import BaseModel, Field


class CheckinIn(BaseModel):
    mood: int = Field(ge=1, le=5)
    sleep: int = Field(ge=1, le=5)
    energy: int = Field(ge=1, le=5)
    note: Optional[str] = Field(default=None, max_length=2000)
    checkin_date: Optional[date] = None  # defaults to today


class CheckinOut(CheckinIn):
    id: str
    checkin_date: date
