from datetime import datetime, timedelta, timezone

from fastapi import Depends, FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware

from .auth import current_user_id
from .config import get_settings
from .db import get_db
from .schemas import (
    BreathingIn, BreathingOut, BreathingStats, CheckinIn, CheckinOut,
    GentleSupportScreen, Helpline, MoodCreated, MoodIn, MoodOut,
    ProfileOut, ProfileUpdate,
)

settings = get_settings()
app = FastAPI(title="Gentle Support API", version="1.0.0")
app.add_middleware(
    CORSMiddleware, allow_origins=settings.cors_origins,
    allow_methods=["*"], allow_headers=["*"],
)

# Routes are plain `def` on purpose: supabase-py is synchronous, and FastAPI
# runs sync routes in a threadpool so they don't block the event loop.

LOW_MOOD_THRESHOLD = 2


def _helplines(country: str) -> list[dict]:
    return (
        get_db().table("helplines").select("name,phone,kind")
        .eq("country_code", country.upper()).eq("is_active", True)
        .order("sort_order").execute().data
    )


def _setting(key: str) -> dict:
    rows = get_db().table("app_settings").select("value").eq("key", key).limit(1).execute().data
    return rows[0]["value"] if rows else {}


@app.get("/health")
def health():
    return {"status": "ok"}


# ---------------- Public: content for the Gentle support screen ----------------

@app.get("/api/v1/gentle-support", response_model=GentleSupportScreen)
def gentle_support(country: str = Query(default=None, min_length=2, max_length=2),
                   locale: str = "en"):
    country = country or settings.default_country
    cards = (
        get_db().table("support_cards").select("slug,title,body,icon,color")
        .eq("is_active", True).eq("locale", locale).order("sort_order").execute().data
    )
    return GentleSupportScreen(
        header=_setting("gentle_support_header"),
        breathing=_setting("breathing"),
        cards=cards,
        help_now=_setting("help_now_notice"),
        helplines=_helplines(country),
    )


@app.get("/api/v1/helplines", response_model=list[Helpline])
def helplines(country: str = Query(default=None, min_length=2, max_length=2)):
    return _helplines(country or settings.default_country)


# ---------------- Breathing ----------------

@app.post("/api/v1/breathing-sessions", response_model=BreathingOut, status_code=201)
def log_breathing(body: BreathingIn, uid: str = Depends(current_user_id)):
    row = get_db().table("breathing_sessions").insert({"user_id": uid, **body.model_dump()}).execute().data[0]
    return row


@app.get("/api/v1/breathing-sessions/stats", response_model=BreathingStats)
def breathing_stats(uid: str = Depends(current_user_id)):
    rows = (
        get_db().table("breathing_sessions").select("duration_seconds,created_at")
        .eq("user_id", uid).execute().data
    )
    week_ago = datetime.now(timezone.utc) - timedelta(days=7)
    recent = sum(1 for r in rows if datetime.fromisoformat(r["created_at"]) >= week_ago)
    return BreathingStats(
        total_sessions=len(rows),
        total_minutes=round(sum(r["duration_seconds"] for r in rows) / 60, 1),
        sessions_last_7_days=recent,
    )


# ---------------- Mood ----------------

@app.post("/api/v1/mood-logs", response_model=MoodCreated, status_code=201)
def log_mood(body: MoodIn, uid: str = Depends(current_user_id)):
    entry = get_db().table("mood_logs").insert({"user_id": uid, **body.model_dump()}).execute().data[0]
    low = body.mood <= LOW_MOOD_THRESHOLD
    helps = []
    if low:
        prof = get_db().table("profiles").select("country_code").eq("id", uid).limit(1).execute().data
        helps = _helplines(prof[0]["country_code"] if prof else settings.default_country)
    return MoodCreated(entry=entry, show_helplines=low, helplines=helps)


@app.get("/api/v1/mood-logs", response_model=list[MoodOut])
def list_mood(limit: int = Query(30, ge=1, le=200), uid: str = Depends(current_user_id)):
    return (
        get_db().table("mood_logs").select("*").eq("user_id", uid)
        .order("created_at", desc=True).limit(limit).execute().data
    )


# ---------------- Small moments of care ----------------

@app.post("/api/v1/care-checkins", response_model=CheckinOut, status_code=201)
def care_checkin(body: CheckinIn, uid: str = Depends(current_user_id)):
    exists = get_db().table("support_cards").select("slug").eq("slug", body.card_slug).limit(1).execute().data
    if not exists:
        raise HTTPException(404, "Unknown support card")
    return get_db().table("care_checkins").insert({"user_id": uid, "card_slug": body.card_slug}).execute().data[0]


@app.get("/api/v1/care-checkins/today", response_model=list[CheckinOut])
def care_today(uid: str = Depends(current_user_id)):
    start = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0)
    return (
        get_db().table("care_checkins").select("*").eq("user_id", uid)
        .gte("created_at", start.isoformat()).order("created_at", desc=True).execute().data
    )


# ---------------- Profile ----------------

@app.get("/api/v1/me", response_model=ProfileOut)
def get_me(uid: str = Depends(current_user_id)):
    rows = get_db().table("profiles").select("*").eq("id", uid).limit(1).execute().data
    if not rows:
        rows = get_db().table("profiles").insert({"id": uid}).execute().data
    return rows[0]


@app.patch("/api/v1/me", response_model=ProfileOut)
def update_me(body: ProfileUpdate, uid: str = Depends(current_user_id)):
    data = {k: (v.upper() if k == "country_code" else v) for k, v in body.model_dump(exclude_unset=True).items()}
    if not data:
        return get_me(uid)
    return get_db().table("profiles").upsert({"id": uid, **data}).execute().data[0]
