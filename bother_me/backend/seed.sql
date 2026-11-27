-- Fake data for local testing. Loaded automatically after schema.sql.
-- With DEV_AUTH=true you can act as these users in /docs using the token  dev:<firebase_uid>
-- e.g.  dev:seed-alice

INSERT INTO users (firebase_uid, username, full_name, email, status) VALUES
  ('seed-alice', 'alice', 'Alice Anderson', 'alice@example.com', 'anywhere'),
  ('seed-bob',   'bob',   'Bob Brown',      'bob@example.com',   'irl'),
  ('seed-cara',  'cara',  'Cara Chen',      'cara@example.com',  'online'),
  ('seed-dev',   'dev',   'Dev Patel',      'dev@example.com',   'dnd');

-- alice<->bob and alice<->cara are friends; dev has a pending request to alice
INSERT INTO friendships (requester_id, addressee_id, accepted) VALUES
  (1, 2, true),
  (3, 1, true),
  (4, 1, false);

INSERT INTO groups (name, owner_id, icon, color) VALUES
  ('Study Group', 1, 'school', '#16A9DC');
INSERT INTO group_members (group_id, user_id) VALUES (1, 1), (1, 2), (1, 3);

-- bob bothers alice individually; alice mass-bothers the study group
INSERT INTO bothers (sender_id, group_id, message) VALUES
  (2, NULL, 'Let''s get dinner and catch up!'),
  (1, 1,    'Do you want to study tomorrow at 6 pm?');
INSERT INTO bother_recipients (bother_id, recipient_id) VALUES
  (1, 1),
  (2, 2), (2, 3);

INSERT INTO messages (sender_id, recipient_id, body) VALUES
  (2, 1, 'Hey, are you free right now?'),
  (1, 2, 'Yes! Library?');
