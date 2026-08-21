-- Query: "Report a Problem" feature — lets residents report potholes,
-- broken streetlights, flooding, garbage collection issues, etc.
-- Run in Supabase → SQL Editor → New Query → Run.

CREATE TABLE IF NOT EXISTS lgu_problem_reports (
  id              BIGSERIAL PRIMARY KEY,
  category        TEXT NOT NULL,
  description     TEXT NOT NULL,
  barangay        TEXT,
  location_detail TEXT,
  photo_url       TEXT,
  reporter_name   TEXT,
  reporter_phone  TEXT,
  status          TEXT DEFAULT 'new',  -- new | in_progress | resolved
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE lgu_problem_reports ENABLE ROW LEVEL SECURITY;

-- Anyone can submit a report
DROP POLICY IF EXISTS "reports_public_insert" ON lgu_problem_reports;
CREATE POLICY "reports_public_insert" ON lgu_problem_reports
  FOR INSERT WITH CHECK (true);

-- Only a genuinely logged-in admin session can read/manage reports —
-- same trust model as lgu_contact_messages. Reporter name/phone is
-- optional but still shouldn't be publicly readable.
DROP POLICY IF EXISTS "reports_admin_select" ON lgu_problem_reports;
CREATE POLICY "reports_admin_select" ON lgu_problem_reports
  FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "reports_admin_update" ON lgu_problem_reports;
CREATE POLICY "reports_admin_update" ON lgu_problem_reports
  FOR UPDATE USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "reports_admin_delete" ON lgu_problem_reports;
CREATE POLICY "reports_admin_delete" ON lgu_problem_reports
  FOR DELETE USING (auth.role() = 'authenticated');

CREATE INDEX IF NOT EXISTS lgu_problem_reports_created_at_idx
  ON lgu_problem_reports (created_at DESC);

-- Storage bucket for photos attached to reports
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('lgu-reports', 'lgu-reports', true, 8388608, ARRAY['image/png','image/jpeg','image/webp'])
ON CONFLICT (id) DO UPDATE SET public = true, file_size_limit = 8388608;

DROP POLICY IF EXISTS "lgu_reports_public_read" ON storage.objects;
CREATE POLICY "lgu_reports_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'lgu-reports');

DROP POLICY IF EXISTS "lgu_reports_public_insert" ON storage.objects;
CREATE POLICY "lgu_reports_public_insert" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'lgu-reports');
