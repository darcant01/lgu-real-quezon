-- ============================================================
--  LGU Real, Quezon Province — Supabase Database Schema
--  Run this in the Supabase SQL Editor (Dashboard > SQL Editor)
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── USERS (admin staff accounts) ─────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_users (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username    TEXT UNIQUE NOT NULL,
  name        TEXT,
  dept        TEXT,
  role        TEXT NOT NULL DEFAULT 'viewer'
                CHECK (role IN ('super','editor','compliance','viewer')),
  pass_hash   TEXT NOT NULL,
  mfa_enabled BOOLEAN DEFAULT FALSE,
  mfa_secret  TEXT DEFAULT '',
  active      BOOLEAN DEFAULT TRUE,
  force_pass_change BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── AUDIT TRAIL ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_audit (
  id          BIGSERIAL PRIMARY KEY,
  type        TEXT NOT NULL,   -- login | logout | save | upload | delete | security
  action      TEXT NOT NULL,
  username    TEXT,
  user_name   TEXT,
  user_role   TEXT,
  ip_address  TEXT DEFAULT '—',
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── SETTINGS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_settings (
  key         TEXT PRIMARY KEY,
  value       TEXT NOT NULL,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── ANNOUNCEMENTS ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_announcements (
  id          BIGSERIAL PRIMARY KEY,
  text        TEXT NOT NULL,
  active      BOOLEAN DEFAULT TRUE,
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── ARTICLES ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_articles (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title       TEXT NOT NULL,
  tag         TEXT DEFAULT 'news',
  summary     TEXT,
  body_html   TEXT,            -- full article body with formatting
  cover_url   TEXT,            -- Supabase Storage URL (not base64)
  date        DATE,
  published   BOOLEAN DEFAULT FALSE,
  author      TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── EVENTS ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_events (
  id          BIGSERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  date        DATE,
  time        TEXT,
  venue       TEXT,
  type        TEXT DEFAULT 'Other',
  description TEXT,
  active      BOOLEAN DEFAULT TRUE,
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── GALLERY ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_gallery (
  id          BIGSERIAL PRIMARY KEY,
  image_url   TEXT NOT NULL,   -- Supabase Storage URL
  caption     TEXT,
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── HERO SLIDES ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_hero_slides (
  id          BIGSERIAL PRIMARY KEY,
  image_url   TEXT NOT NULL,   -- Supabase Storage URL
  caption     TEXT,
  subtitle    TEXT,
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── OFFICIALS ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_officials (
  id          BIGSERIAL PRIMARY KEY,
  name        TEXT,
  role        TEXT,
  bio         TEXT,
  party       TEXT,
  term        TEXT,
  emoji       TEXT DEFAULT '🧑‍💼',
  photo_url   TEXT,            -- Supabase Storage URL
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── SERVICES ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_services (
  id          BIGSERIAL PRIMARY KEY,
  icon        TEXT DEFAULT '📋',
  title       TEXT NOT NULL,
  description TEXT,
  link        TEXT DEFAULT '#',
  arrow       TEXT DEFAULT 'Learn More',
  sort_order  INT DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── DOCUMENTS (Transparency) ──────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_documents (
  id          BIGSERIAL PRIMARY KEY,
  title       TEXT NOT NULL,
  category    TEXT DEFAULT 'Other',
  type        TEXT DEFAULT 'PDF',
  url         TEXT NOT NULL,
  date        DATE,
  active      BOOLEAN DEFAULT TRUE,
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── BARANGAYS ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_barangays (
  id          BIGSERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  emoji       TEXT DEFAULT '🏘️',
  captain     TEXT,
  population  TEXT,
  area        TEXT,
  description TEXT,
  sort_order  INT DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── DIRECTORY ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_directory (
  id          BIGSERIAL PRIMARY KEY,
  dept        TEXT,
  name        TEXT NOT NULL,
  head        TEXT,
  phone       TEXT,
  email       TEXT,
  hours       TEXT DEFAULT 'Mon–Fri, 8AM–5PM',
  sort_order  INT DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── FAQ ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_faq (
  id          BIGSERIAL PRIMARY KEY,
  question    TEXT NOT NULL,
  answer      TEXT NOT NULL,
  sort_order  INT DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── ALERT ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_alert (
  id          INT PRIMARY KEY DEFAULT 1,  -- single row
  active      BOOLEAN DEFAULT FALSE,
  title       TEXT DEFAULT '',
  body        TEXT DEFAULT '',
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO lgu_alert (id, active, title, body) VALUES (1, FALSE, '', '')
  ON CONFLICT (id) DO NOTHING;

-- ============================================================
--  ROW LEVEL SECURITY (RLS)
--  Public site reads data without auth.
--  Admin writes require a valid JWT (Supabase Auth session).
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE lgu_users        ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_audit        ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_settings     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_articles     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_events       ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_gallery      ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_hero_slides  ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_officials    ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_services     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_documents    ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_barangays    ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_directory    ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_faq          ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_alert        ENABLE ROW LEVEL SECURITY;

-- PUBLIC READ (anon key) — content tables only
CREATE POLICY "Public can read announcements"  ON lgu_announcements  FOR SELECT USING (TRUE);
CREATE POLICY "Public can read articles"       ON lgu_articles       FOR SELECT USING (published = TRUE);
CREATE POLICY "Public can read events"         ON lgu_events         FOR SELECT USING (active = TRUE);
CREATE POLICY "Public can read gallery"        ON lgu_gallery        FOR SELECT USING (TRUE);
CREATE POLICY "Public can read hero slides"    ON lgu_hero_slides    FOR SELECT USING (TRUE);
CREATE POLICY "Public can read officials"      ON lgu_officials      FOR SELECT USING (TRUE);
CREATE POLICY "Public can read services"       ON lgu_services       FOR SELECT USING (TRUE);
CREATE POLICY "Public can read documents"      ON lgu_documents      FOR SELECT USING (active = TRUE);
CREATE POLICY "Public can read barangays"      ON lgu_barangays      FOR SELECT USING (TRUE);
CREATE POLICY "Public can read directory"      ON lgu_directory      FOR SELECT USING (TRUE);
CREATE POLICY "Public can read faq"            ON lgu_faq            FOR SELECT USING (TRUE);
CREATE POLICY "Public can read alert"          ON lgu_alert          FOR SELECT USING (TRUE);
CREATE POLICY "Public can read settings"       ON lgu_settings       FOR SELECT USING (TRUE);

-- ADMIN WRITE (authenticated users with role stored in JWT metadata)
-- Users table: only super admins can read/write
CREATE POLICY "Super admins manage users"      ON lgu_users
  FOR ALL USING (auth.jwt() ->> 'user_role' = 'super');

CREATE POLICY "Admins can write announcements" ON lgu_announcements
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','editor'));

CREATE POLICY "Admins can write articles"      ON lgu_articles
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','editor'));

CREATE POLICY "Admins can write events"        ON lgu_events
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','editor'));

CREATE POLICY "Admins can write gallery"       ON lgu_gallery
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','editor'));

CREATE POLICY "Admins can write hero slides"   ON lgu_hero_slides
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','editor'));

CREATE POLICY "Admins can write officials"     ON lgu_officials
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','editor'));

CREATE POLICY "Admins can write services"      ON lgu_services
  FOR ALL USING (auth.jwt() ->> 'user_role' = 'super');

CREATE POLICY "Compliance can write documents" ON lgu_documents
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','compliance'));

CREATE POLICY "Admins can write barangays"     ON lgu_barangays
  FOR ALL USING (auth.jwt() ->> 'user_role' = 'super');

CREATE POLICY "Admins can write directory"     ON lgu_directory
  FOR ALL USING (auth.jwt() ->> 'user_role' = 'super');

CREATE POLICY "Admins can write faq"           ON lgu_faq
  FOR ALL USING (auth.jwt() ->> 'user_role' = 'super');

CREATE POLICY "Admins can write alert"         ON lgu_alert
  FOR ALL USING (auth.jwt() ->> 'user_role' IN ('super','editor'));

CREATE POLICY "Admins can write settings"      ON lgu_settings
  FOR ALL USING (auth.jwt() ->> 'user_role' = 'super');

CREATE POLICY "Super admins read audit"        ON lgu_audit
  FOR SELECT USING (auth.jwt() ->> 'user_role' = 'super');

CREATE POLICY "System can write audit"         ON lgu_audit
  FOR INSERT WITH CHECK (TRUE);

-- ============================================================
--  STORAGE BUCKETS  (run in Supabase Dashboard > Storage)
--  Or via the Supabase CLI: supabase storage create <bucket>
-- ============================================================
-- NOTE: Create these buckets manually in the Supabase Dashboard:
--   • lgu-images  (public)  — hero slides, gallery, officials, article covers
--   • lgu-docs    (public)  — PDF documents, downloadable files
--   • lgu-logo    (public)  — site logo
-- Set max file size: lgu-images = 5MB, lgu-docs = 10MB, lgu-logo = 2MB

-- ============================================================
--  FUNCTIONS & TRIGGERS
-- ============================================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_articles_updated   BEFORE UPDATE ON lgu_articles   FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_officials_updated  BEFORE UPDATE ON lgu_officials  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_settings_updated   BEFORE UPDATE ON lgu_settings   FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_services_updated   BEFORE UPDATE ON lgu_services   FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_barangays_updated  BEFORE UPDATE ON lgu_barangays  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_directory_updated  BEFORE UPDATE ON lgu_directory  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_faq_updated        BEFORE UPDATE ON lgu_faq        FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_users_updated      BEFORE UPDATE ON lgu_users      FOR EACH ROW EXECUTE FUNCTION update_updated_at();
