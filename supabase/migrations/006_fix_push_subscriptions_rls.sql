-- ═══════════════════════════════════════════════════════════════
--  FIX — lgu_push_subscriptions row-level security policies
--  Run in Supabase → SQL Editor → New Query → Run.
--
--  Fixes: "new row violates row-level security policy for table
--  lgu_push_subscriptions" when a visitor taps "Get Alerts".
--
--  Root cause: the app uses an UPSERT (insert-or-update) to save each
--  device's push subscription, but the original migration only created
--  INSERT and DELETE policies — no UPDATE policy. This adds the
--  missing UPDATE policy and re-confirms INSERT/DELETE, safe to re-run.
-- ═══════════════════════════════════════════════════════════════

-- Make sure the table actually has RLS enabled (harmless if already on)
ALTER TABLE lgu_push_subscriptions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "push_sub_public_insert" ON lgu_push_subscriptions;
CREATE POLICY "push_sub_public_insert" ON lgu_push_subscriptions
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "push_sub_public_update" ON lgu_push_subscriptions;
CREATE POLICY "push_sub_public_update" ON lgu_push_subscriptions
  FOR UPDATE USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "push_sub_public_delete" ON lgu_push_subscriptions;
CREATE POLICY "push_sub_public_delete" ON lgu_push_subscriptions
  FOR DELETE USING (true);

-- Still intentionally NO public SELECT policy — the subscriber list
-- must not be readable by anonymous visitors. Only the server-side
-- send-alert-push function (service role key, bypasses RLS) reads it.

-- Quick sanity check — should return the 3 policies above
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'lgu_push_subscriptions';
