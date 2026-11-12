from datetime import datetime
from typing import Any
from pydantic import BaseModel, Field


class SupportCard(BaseModel):
    slug: str
    title: str
    body: str
    icon: str
    color: str


class Helpline(BaseModel):
    name: str
    phone: str
    kind: str


class GentleSupportScreen(BaseModel):
    header: dict[str, Any]
    breathing: dict[str, Any]
    cards: list[SupportCard]
    help_now: dict[str, Any]
    helplines: list[Helpline]


class BreathingIn(BaseModel):
    duration_seconds: int = Field(ge=1, le=3600)
    cycles: int = Field(default=0, ge=0, le=1000)


class BreathingOut(BreathingIn):
    id: str
    created_at: datetime


class BreathingStats(BaseModel):
    total_sessions: int
    total_minutes: float
    sessions_last_7_days: int


class MoodIn(BaseModel):
    mood: int = Field(ge=1, le=5, description="1 = very low, 5 = very good")
    note: str | None = Field(default=None, max_length=1000)


class MoodOut(MoodIn):
    id: str
    created_at: datetime


class MoodCreated(BaseModel):
    entry: MoodOut
    show_helplines: bool          # True when mood is low -> app should surface helplines
    helplines: list[Helpline] = []


class CheckinIn(BaseModel):
    card_slug: str


class CheckinOut(BaseModel):
    id: str
    card_slug: str
    created_at: datetime


class ProfileOut(BaseModel):
    id: str
    display_name: str | None
    country_code: str


class ProfileUpdate(BaseModel):
    display_name: str | None = Field(default=None, max_length=60)
    country_code: str | None = Field(default=None, min_length=2, max_length=2)
