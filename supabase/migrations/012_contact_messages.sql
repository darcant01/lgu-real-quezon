-- Query: Contact form submissions. Run in Supabase → SQL Editor → New
-- Query → Run.
--
-- These contain real personal information (name, email, message
-- content) — unlike other tables in this app, this must NEVER be
-- publicly readable with the anon key the public site uses. Instead of
-- the SECURITY DEFINER function pattern used for push subscription
-- counts (which only exposes aggregate numbers), this table uses a
-- cleaner mechanism available here: the admin panel performs a REAL
-- Supabase Auth login (_sb.auth.signInWithPassword), so its session is
-- genuinely "authenticated", not just holding the same public anon
-- key as every visitor. RLS below grants full read/write only to that
-- authenticated role — anonymous visitors can only ever INSERT their
-- own submission, never read anyone else's.

CREATE TABLE IF NOT EXISTS lgu_contact_messages (
  id          BIGSERIAL PRIMARY KEY,
  first_name  TEXT,
  last_name   TEXT,
  email       TEXT,
  barangay    TEXT,
  subject     TEXT,
  message     TEXT NOT NULL,
  status      TEXT DEFAULT 'new',  -- 'new' | 'read' | 'replied' | 'archived'
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE lgu_contact_messages ENABLE ROW LEVEL SECURITY;

-- Anyone can submit the contact form
DROP POLICY IF EXISTS "contact_public_insert" ON lgu_contact_messages;
CREATE POLICY "contact_public_insert" ON lgu_contact_messages
  FOR INSERT WITH CHECK (true);

-- Only a real logged-in admin session can read, update (mark as
-- read/replied/archived), or delete messages
DROP POLICY IF EXISTS "contact_authenticated_read" ON lgu_contact_messages;
CREATE POLICY "contact_authenticated_read" ON lgu_contact_messages
  FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "contact_authenticated_update" ON lgu_contact_messages;
CREATE POLICY "contact_authenticated_update" ON lgu_contact_messages
  FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "contact_authenticated_delete" ON lgu_contact_messages;
CREATE POLICY "contact_authenticated_delete" ON lgu_contact_messages
  FOR DELETE USING (auth.role() = 'authenticated');

CREATE INDEX IF NOT EXISTS lgu_contact_messages_created_at_idx
  ON lgu_contact_messages (created_at DESC);
