-- Query: Enable Supabase Realtime on lgu_kv so Emergency Alert changes
-- push live to every visitor's browser instantly (no page refresh needed).
-- Run in Supabase → SQL Editor → New Query → Run. Safe to re-run.
--
-- Without this, the table can be read/written fine, but change events
-- won't be broadcast over Realtime's websocket — the site would only
-- ever see the alert on the next page load.

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND tablename = 'lgu_kv'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE lgu_kv;
  END IF;
END $$;

-- Sanity check — should show lgu_kv in the list of realtime-enabled tables
SELECT schemaname, tablename FROM pg_publication_tables WHERE pubname = 'supabase_realtime';
