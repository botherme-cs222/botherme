from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routers import users

app = FastAPI(title="BotherMe API")

# Allow Flutter web / local tools to call the API during development
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

app.include_router(users.router)
# Add your feature's router here, e.g.:
# from .routers import friends
# app.include_router(friends.router)


@app.get("/health")
def health():
    return {"ok": True}
