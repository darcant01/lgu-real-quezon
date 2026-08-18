-- Query: Privacy-friendly, self-hosted visitor analytics.
-- Run in Supabase → SQL Editor → New Query → Run.
--
-- Deliberately minimal — no IP addresses, no cookies, no user-agent
-- strings, no persistent visitor ID linking multiple visits together.
-- Just: which day, roughly what device, and where the visitor came
-- from. Nothing here identifies an individual, so — unlike other
-- tables in this app (e.g. push subscriptions) — public SELECT is
-- safe: aggregate view counts carry the same trust level as a public
-- "views" counter, not personal data.

CREATE TABLE IF NOT EXISTS lgu_analytics_events (
  id          BIGSERIAL PRIMARY KEY,
  device      TEXT,              -- 'mobile' | 'desktop'
  referrer    TEXT,               -- referring hostname, or 'direct'
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE lgu_analytics_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "analytics_public_insert" ON lgu_analytics_events;
CREATE POLICY "analytics_public_insert" ON lgu_analytics_events
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "analytics_public_read" ON lgu_analytics_events;
CREATE POLICY "analytics_public_read" ON lgu_analytics_events
  FOR SELECT USING (true);

-- Speeds up the admin dashboard's "last 90 days" query
CREATE INDEX IF NOT EXISTS lgu_analytics_events_created_at_idx
  ON lgu_analytics_events (created_at DESC);
