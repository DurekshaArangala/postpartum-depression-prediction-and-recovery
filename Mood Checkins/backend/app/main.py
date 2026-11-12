from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routes import checkins

app = FastAPI(title="Daily Check-in API")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])
app.include_router(checkins.router)


@app.get("/health")
def health():
    return {"ok": True}
