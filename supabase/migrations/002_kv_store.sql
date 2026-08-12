-- Query: Create shared key-value store for LGU Real content
-- This table backs all admin panel content (announcements, articles, 
-- events, officials, etc.) using the existing app's key-value model.

CREATE TABLE IF NOT EXISTS lgu_kv (
  key         TEXT PRIMARY KEY,
  value       JSONB NOT NULL,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE lgu_kv ENABLE ROW LEVEL SECURITY;

-- Query: Public can read all content (powers the public website)
CREATE POLICY "kv_public_read" ON lgu_kv
  FOR SELECT USING (true);

-- Query: Anyone can write (admin panel's own login/RBAC gates access at the UI level)
-- NOTE: For stronger DB-level security, migrate to Supabase Auth-gated policies later.
CREATE POLICY "kv_public_insert" ON lgu_kv
  FOR INSERT WITH CHECK (true);

CREATE POLICY "kv_public_update" ON lgu_kv
  FOR UPDATE USING (true);

CREATE POLICY "kv_public_delete" ON lgu_kv
  FOR DELETE USING (true);

-- Query: Auto-update timestamp on every write
CREATE OR REPLACE FUNCTION update_kv_timestamp()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_kv_updated
  BEFORE UPDATE ON lgu_kv
  FOR EACH ROW EXECUTE FUNCTION update_kv_timestamp();
