from fastapi import Header, HTTPException
from .config import supabase


def current_user_id(authorization: str = Header(...)) -> str:
    """Validate the Supabase access token sent by the mobile app."""
    token = authorization.removeprefix("Bearer ").strip()
    try:
        return supabase.auth.get_user(token).user.id
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired session")
