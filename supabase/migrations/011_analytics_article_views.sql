-- Query: Extend the analytics table to support tracking specific
-- content views (starting with articles), not just generic pageviews.
-- Run in Supabase → SQL Editor → New Query → Run. Safe to re-run.

ALTER TABLE lgu_analytics_events ADD COLUMN IF NOT EXISTS event_type TEXT DEFAULT 'pageview';
ALTER TABLE lgu_analytics_events ADD COLUMN IF NOT EXISTS label TEXT;

-- Speeds up the admin dashboard's "top articles" aggregation query
CREATE INDEX IF NOT EXISTS lgu_analytics_events_type_label_idx
  ON lgu_analytics_events (event_type, label);
