from calendar import monthrange
from datetime import date, datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, Query
from ..auth import current_user_id
from ..config import supabase
from ..schemas import CheckinIn, CheckinOut

router = APIRouter(prefix="/checkins", tags=["checkins"])
T = "checkins"


@router.post("", response_model=CheckinOut)
def save_checkin(body: CheckinIn, uid: str = Depends(current_user_id)):
    """Create or update the check-in for a day (one per day)."""
    day = body.checkin_date or date.today()
    row = {**body.model_dump(exclude={"checkin_date"}), "user_id": uid,
           "checkin_date": day.isoformat(),
           "updated_at": datetime.now(timezone.utc).isoformat()}
    res = supabase.table(T).upsert(row, on_conflict="user_id,checkin_date").execute()
    return res.data[0]


@router.get("", response_model=list[CheckinOut])
def list_month(month: str = Query(pattern=r"^\d{4}-\d{2}$"), uid: str = Depends(current_user_id)):
    """All check-ins for a month, e.g. ?month=2026-11 (feeds the calendar)."""
    y, m = map(int, month.split("-"))
    start, end = date(y, m, 1), date(y, m, monthrange(y, m)[1])
    res = (supabase.table(T).select("*").eq("user_id", uid)
           .gte("checkin_date", start.isoformat()).lte("checkin_date", end.isoformat())
           .order("checkin_date").execute())
    return res.data


@router.get("/{day}", response_model=CheckinOut)
def get_day(day: date, uid: str = Depends(current_user_id)):
    res = (supabase.table(T).select("*").eq("user_id", uid)
           .eq("checkin_date", day.isoformat()).limit(1).execute())
    if not res.data:
        raise HTTPException(404, "No check-in for this day")
    return res.data[0]
