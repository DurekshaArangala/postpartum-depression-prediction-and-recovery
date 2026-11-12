# Daily Check-in

Folders: `database/` (SQL), `backend/` (FastAPI + Supabase), `mobile/` (Expo React Native).

## 1. Database
Supabase dashboard → SQL Editor → run `database/schema.sql`.

## 2. Backend
```
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env     # fill in Supabase URL + service role key
uvicorn app.main:app --reload --host 0.0.0.0
```
Docs: http://localhost:8000/docs

Endpoints (Bearer = Supabase access token):
- POST /checkins          save/update today's check-in
- GET  /checkins?month=YYYY-MM   check-ins for the calendar
- GET  /checkins/{YYYY-MM-DD}    one day

## 3. Mobile
```
cd mobile
# edit src/config.js (API_URL, Supabase URL + anon key)
npm install
npx expo start
```
Scan the QR code with Expo Go.
