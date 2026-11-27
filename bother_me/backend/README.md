# BotherMe Backend

Flutter app → **FastAPI** (Python) → **PostgreSQL** (Docker)

Login stays in Firebase. The app sends its Firebase ID token with every request, and the backend verifies it.

## One-time setup

You need **Docker** and **Python 3.9+**.

```bash
cd bother_me/backend
cp .env.example .env               # local settings (no real secrets)
docker compose up -d               # starts Postgres on localhost:5433, creates tables + seed data
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run it

```bash
docker compose up -d                       # if the DB isn't already running
source .venv/bin/activate
uvicorn app.main:app --reload
```

Open **http://localhost:8000/docs** to see and try every endpoint.

### Testing without the app
With `DEV_AUTH=true` in `.env`, click **Authorize** in `/docs` and enter `dev:seed-alice` (or `dev:seed-bob`, `dev:seed-cara`, `dev:seed-dev`). You're now acting as that seed user. Never turn this on for a deployed server.

### Looking at the database
```bash
docker compose exec db psql -U botherme      # then e.g.  \dt   or   SELECT * FROM users;
```

## Files

| File | What it is |
|---|---|
| `schema.sql` | **The database tables. This is the source of truth.** |
| `seed.sql` | Fake users, friends, groups and bothers for testing |
| `app/main.py` | Creates the app and registers routers |
| `app/models.py` | Python classes for each table, plus request/response shapes |
| `app/auth.py` | `get_current_user` checks the Firebase token and returns the user's row |
| `app/db.py` | Database connection (`get_session`) |
| `app/routers/users.py` | **Example router**: register, view and update your profile and status |

## Tables (see `schema.sql`)

| Table | Used for |
|---|---|
| `users` | Profile + status (`irl`, `online`, `anywhere`, `dnd`) |
| `friendships` | Friend requests. `accepted = false` means pending |
| `groups`, `group_members` | Friend groups |
| `bothers`, `bother_recipients` | Bother requests. A group bother has one row per recipient. The notifications tab reads `bother_recipients` |
| `messages` | 1-on-1 messages |

## Existing endpoints

| Method | Path | What |
|---|---|---|
| GET | `/health` | Server is up |
| POST | `/users/me` | Register after Firebase sign-up. Body `{"username": "...", "full_name": "..."}` |
| GET | `/users/me` | My profile |
| PATCH | `/users/me` | Update `status` and/or `full_name` |
| GET | `/users/search?q=al` | Find users by username prefix |

## Adding your feature

1. **Need a new column or table?** Edit `schema.sql`, update the matching class in `app/models.py`, then reset your DB:
   ```bash
   docker compose down -v && docker compose up -d     # wipes local data, re-runs schema + seed
   ```
   Tell the team, because everyone runs that same command after pulling.
2. **Create `app/routers/<feature>.py`**, copying the pattern in `users.py`:
   ```python
   from fastapi import APIRouter, Depends
   from sqlmodel import Session, select
   from ..auth import get_current_user
   from ..db import get_session
   from ..models import User, Friendship

   router = APIRouter(prefix="/friends", tags=["friends"])

   @router.get("")
   def list_friends(me: User = Depends(get_current_user), session: Session = Depends(get_session)):
       return session.exec(select(Friendship).where(Friendship.requester_id == me.id)).all()
   ```
3. **Register it** in `app/main.py`: `app.include_router(friends.router)`.
4. Try it at `/docs`.

## Connecting a Flutter page

Use `bother_me/lib/services/api.dart`. It adds the Firebase token for you.

```dart
import '../services/api.dart';

final me = await Api.get('/users/me');                 // Map
await Api.patch('/users/me', {'status': 'irl'});
final results = await Api.get('/users/search?q=al');   // List
```

Base URL: Android emulator → `10.0.2.2:8000`, iOS simulator → `localhost:8000`. A physical phone needs your computer's LAN IP, so edit `baseUrl` in `api.dart`.

## Secrets

- The DB password in `.env` is local-only and not a secret.
- Verifying Firebase tokens needs only the public project ID, so there's no key file.
- Later, push notifications (FCM) will need a Firebase service-account JSON. Share it privately, save it as `bother_me/backend/firebase-key.json` (already git-ignored), and **never commit it**.
