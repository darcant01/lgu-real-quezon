-- Query: Safe way to show "how many devices are subscribed to
-- Emergency Alerts" on the admin Dashboard, without exposing the
-- actual subscriber list (endpoints/keys) to the public anon key.
-- Run in Supabase → SQL Editor → New Query → Run.
--
-- lgu_push_subscriptions intentionally has NO public SELECT policy —
-- if it did, anyone with the site's anon key could read every
-- subscriber's push endpoint and spam them with fake notifications.
-- This function runs as SECURITY DEFINER (bypasses RLS internally) but
-- only ever returns a timestamp, never the endpoint/keys — safe to
-- expose to anon, since a bare list of "when someone subscribed"
-- carries none of the risk the endpoint data does.

CREATE OR REPLACE FUNCTION get_push_subscription_timestamps(days_back int DEFAULT 90)
RETURNS TABLE(created_at timestamptz)
SECURITY DEFINER
SET search_path = public
LANGUAGE sql
AS $$
  SELECT created_at
  FROM lgu_push_subscriptions
  WHERE created_at >= now() - (days_back || ' days')::interval
  ORDER BY created_at DESC;
$$;

GRANT EXECUTE ON FUNCTION get_push_subscription_timestamps(int) TO anon, authenticated;
