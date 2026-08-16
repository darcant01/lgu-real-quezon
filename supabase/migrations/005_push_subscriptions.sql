-- Query: Web Push subscriptions for Emergency Alert notifications.
-- Run in Supabase → SQL Editor → New Query → Run.

CREATE TABLE IF NOT EXISTS lgu_push_subscriptions (
  id          BIGSERIAL PRIMARY KEY,
  endpoint    TEXT UNIQUE NOT NULL,
  p256dh      TEXT NOT NULL,
  auth        TEXT NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE lgu_push_subscriptions ENABLE ROW LEVEL SECURITY;

-- Visitors can save their own subscription when they enable alerts
DROP POLICY IF EXISTS "push_sub_public_insert" ON lgu_push_subscriptions;
CREATE POLICY "push_sub_public_insert" ON lgu_push_subscriptions
  FOR INSERT WITH CHECK (true);

-- Visitors can remove their own subscription (e.g. if they disable alerts)
-- Matching is done by endpoint, which only that browser knows.
DROP POLICY IF EXISTS "push_sub_public_delete" ON lgu_push_subscriptions;
CREATE POLICY "push_sub_public_delete" ON lgu_push_subscriptions
  FOR DELETE USING (true);

-- Intentionally NO public SELECT policy — the list of who has
-- subscribed must not be readable by anonymous visitors (it would let
-- anyone harvest push endpoints and spam them). Only the server-side
-- send-alert-push function (using the Supabase service role key, which
-- bypasses RLS entirely) can read this table to actually send pushes.
