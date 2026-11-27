-- BotherMe database schema.
-- Docker runs this automatically the FIRST time the database volume is created.
-- After editing this file, reset your local DB:  docker compose down -v && docker compose up -d
-- Remember to update app/models.py to match.

CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  firebase_uid  TEXT UNIQUE NOT NULL,
  username      TEXT UNIQUE NOT NULL,
  full_name     TEXT,
  email         TEXT UNIQUE NOT NULL,
  -- TEXT + CHECK (not an ENUM) so adding a status is a one-line change
  status        TEXT NOT NULL DEFAULT 'anywhere'
                CHECK (status IN ('irl', 'online', 'anywhere', 'dnd')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- One row per friend request. accepted = true means they are friends.
-- Query both directions (requester OR addressee) to find someone's friends.
CREATE TABLE friendships (
  requester_id  INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  addressee_id  INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  accepted      BOOLEAN NOT NULL DEFAULT false,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (requester_id, addressee_id),
  CHECK (requester_id <> addressee_id)
);

CREATE TABLE groups (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  owner_id   INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  icon       TEXT,
  color      TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE group_members (
  group_id  INT NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  user_id   INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  PRIMARY KEY (group_id, user_id)
);

-- A "bother" is a request/ping. A group (mass) bother creates one bother
-- plus one bother_recipients row per member.
CREATE TABLE bothers (
  id            SERIAL PRIMARY KEY,
  sender_id     INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  group_id      INT REFERENCES groups(id) ON DELETE SET NULL,  -- NULL = individual
  message       TEXT NOT NULL,
  scheduled_at  TIMESTAMPTZ,                                   -- NULL = send now
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- The notifications tab reads from here.
CREATE TABLE bother_recipients (
  bother_id     INT NOT NULL REFERENCES bothers(id) ON DELETE CASCADE,
  recipient_id  INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  read_at       TIMESTAMPTZ,                                   -- NULL = unread
  PRIMARY KEY (bother_id, recipient_id)
);

CREATE TABLE messages (
  id            SERIAL PRIMARY KEY,
  sender_id     INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipient_id  INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body          TEXT NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX messages_conversation_idx ON messages (sender_id, recipient_id, created_at);
