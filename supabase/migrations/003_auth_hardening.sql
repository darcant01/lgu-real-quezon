-- Query: Tighten lgu_kv write access to require real Supabase Auth sessions
-- Run this AFTER creating your admin user in Authentication > Users

-- Remove the fully-open write policies from the initial setup
DROP POLICY IF EXISTS "kv_public_insert" ON lgu_kv;
DROP POLICY IF EXISTS "kv_public_update" ON lgu_kv;
DROP POLICY IF EXISTS "kv_public_delete" ON lgu_kv;

-- Query: Only authenticated (logged-in) users can write
CREATE POLICY "kv_auth_insert" ON lgu_kv
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "kv_auth_update" ON lgu_kv
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "kv_auth_delete" ON lgu_kv
  FOR DELETE USING (auth.role() = 'authenticated');

-- Public read access is unchanged — the public website still needs this
-- (kv_public_read policy from 002_kv_store.sql remains active)
