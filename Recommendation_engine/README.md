# Gentle Support Backend (FastAPI + Supabase/PostgreSQL)

## Setup
1. Create a Supabase project. In **SQL Editor**, run `schema.sql` (tables, RLS, seed content).
2. `cp .env.example .env` and fill `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`
   (Project Settings -> API).
3. Install and run:
   ```bash
   python -m venv .venv && source .venv/bin/activate
   pip install -r requirements.txt
   uvicorn app.main:app --reload
   ```
4. Open http://localhost:8000/docs

## Auth
Sign users up/in from the app with Supabase Auth (supabase-js / supabase-flutter).
Send the access token on protected calls: `Authorization: Bearer <access_token>`.

## Endpoints
| Method | Path | Auth | Purpose |
|---|---|---|---|
| GET | /api/v1/gentle-support?country=LK | no | Whole screen: header, breathing config, cards, helplines |
| GET | /api/v1/helplines?country=LK | no | Helplines only |
| POST | /api/v1/breathing-sessions | yes | Log a finished breathing session |
| GET | /api/v1/breathing-sessions/stats | yes | Totals + last 7 days |
| POST/GET | /api/v1/mood-logs | yes | Log / list mood (1-5). Low mood returns `show_helplines: true` |
| POST | /api/v1/care-checkins | yes | Mark a card (rest / connect / care) as done |
| GET | /api/v1/care-checkins/today | yes | Today's check-ins |
| GET/PATCH | /api/v1/me | yes | Profile (name, country) |

