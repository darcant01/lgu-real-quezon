-- ═══════════════════════════════════════════════════════════════
--  LGU Real, Quezon Province — Supabase Database Schema
--  VERSION: 1.0
--
--  HOW TO USE:
--  1. Go to your Supabase project dashboard
--  2. Click "SQL Editor" in the left sidebar
--  3. Click "New Query"
--  4. Paste this ENTIRE file and click "Run"
-- ═══════════════════════════════════════════════════════════════

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── ALERT BANNER ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_alert (
  id         INT PRIMARY KEY DEFAULT 1,
  active     BOOLEAN DEFAULT FALSE,
  title      TEXT DEFAULT '',
  body       TEXT DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO lgu_alert (id, active, title, body)
  VALUES (1, FALSE, '', '')
  ON CONFLICT (id) DO NOTHING;

-- ── ANNOUNCEMENTS (ticker bar) ───────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_announcements (
  id         BIGSERIAL PRIMARY KEY,
  text       TEXT NOT NULL,
  active     BOOLEAN DEFAULT TRUE,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── ARTICLES (news) ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_articles (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title      TEXT NOT NULL,
  tag        TEXT DEFAULT 'news',
  summary    TEXT,
  body_html  TEXT,
  cover_url  TEXT,
  date       DATE,
  published  BOOLEAN DEFAULT FALSE,
  author     TEXT,
  has_images BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
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
  id         BIGSERIAL PRIMARY KEY,
  image_url  TEXT NOT NULL,
  caption    TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── HERO SLIDES ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_hero_slides (
  id         BIGSERIAL PRIMARY KEY,
  image_url  TEXT NOT NULL,
  caption    TEXT,
  subtitle   TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── OFFICIALS ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_officials (
  id         BIGSERIAL PRIMARY KEY,
  name       TEXT,
  role       TEXT,
  bio        TEXT,
  party      TEXT,
  term       TEXT,
  emoji      TEXT DEFAULT '🧑‍💼',
  photo_url  TEXT,
  sort_order INT DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── SERVICES (citizen services cards) ────────────────────────
CREATE TABLE IF NOT EXISTS lgu_services (
  id          BIGSERIAL PRIMARY KEY,
  icon        TEXT DEFAULT '📋',
  title       TEXT NOT NULL,
  description TEXT,
  link        TEXT DEFAULT '#',
  arrow       TEXT DEFAULT 'Learn More',
  sort_order  INT DEFAULT 0
);

-- ── DOCUMENTS (transparency / FOI) ───────────────────────────
CREATE TABLE IF NOT EXISTS lgu_documents (
  id         BIGSERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  category   TEXT DEFAULT 'Other',
  type       TEXT DEFAULT 'PDF',
  url        TEXT NOT NULL,
  active     BOOLEAN DEFAULT TRUE,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── BARANGAY PROFILES ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_barangays (
  id          BIGSERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  emoji       TEXT DEFAULT '🏘️',
  captain     TEXT,
  population  TEXT,
  area        TEXT,
  description TEXT,
  sort_order  INT DEFAULT 0
);

-- ── DEPARTMENT DIRECTORY ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_directory (
  id         BIGSERIAL PRIMARY KEY,
  dept       TEXT,
  name       TEXT NOT NULL,
  head       TEXT,
  phone      TEXT,
  email      TEXT,
  hours      TEXT DEFAULT 'Mon–Fri, 8AM–5PM',
  sort_order INT DEFAULT 0
);

-- ── FAQ ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_faq (
  id         BIGSERIAL PRIMARY KEY,
  question   TEXT NOT NULL,
  answer     TEXT NOT NULL,
  sort_order INT DEFAULT 0
);

-- ── SETTINGS (key-value store) ────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_settings (
  key        TEXT PRIMARY KEY,
  value      TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── ADMIN USERS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_users (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  username          TEXT UNIQUE NOT NULL,
  name              TEXT,
  dept              TEXT,
  role              TEXT NOT NULL DEFAULT 'viewer'
                      CHECK (role IN ('super','editor','compliance','viewer')),
  pass_hash         TEXT NOT NULL,
  mfa_enabled       BOOLEAN DEFAULT FALSE,
  mfa_secret        TEXT DEFAULT '',
  active            BOOLEAN DEFAULT TRUE,
  force_pass_change BOOLEAN DEFAULT TRUE,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

-- ── AUDIT TRAIL ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lgu_audit (
  id         BIGSERIAL PRIMARY KEY,
  type       TEXT NOT NULL,
  action     TEXT NOT NULL,
  username   TEXT,
  user_name  TEXT,
  user_role  TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ═══════════════════════════════════════════════════════════════
--  ROW LEVEL SECURITY (RLS)
--  Public can READ content. Only authenticated admins can WRITE.
-- ═══════════════════════════════════════════════════════════════

ALTER TABLE lgu_alert         ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_articles      ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_events        ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_gallery       ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_hero_slides   ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_officials     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_services      ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_documents     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_barangays     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_directory     ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_faq           ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_settings      ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_users         ENABLE ROW LEVEL SECURITY;
ALTER TABLE lgu_audit         ENABLE ROW LEVEL SECURITY;

-- PUBLIC READ policies (anyone with anon key can read)
CREATE POLICY "public_read_alert"         ON lgu_alert         FOR SELECT USING (true);
CREATE POLICY "public_read_announcements" ON lgu_announcements FOR SELECT USING (true);
CREATE POLICY "public_read_articles"      ON lgu_articles      FOR SELECT USING (published = true);
CREATE POLICY "public_read_events"        ON lgu_events        FOR SELECT USING (active = true);
CREATE POLICY "public_read_gallery"       ON lgu_gallery       FOR SELECT USING (true);
CREATE POLICY "public_read_hero"          ON lgu_hero_slides   FOR SELECT USING (true);
CREATE POLICY "public_read_officials"     ON lgu_officials     FOR SELECT USING (true);
CREATE POLICY "public_read_services"      ON lgu_services      FOR SELECT USING (true);
CREATE POLICY "public_read_documents"     ON lgu_documents     FOR SELECT USING (active = true);
CREATE POLICY "public_read_barangays"     ON lgu_barangays     FOR SELECT USING (true);
CREATE POLICY "public_read_directory"     ON lgu_directory     FOR SELECT USING (true);
CREATE POLICY "public_read_faq"           ON lgu_faq           FOR SELECT USING (true);
CREATE POLICY "public_read_settings"      ON lgu_settings      FOR SELECT USING (true);

-- ADMIN WRITE policies (authenticated session required)
CREATE POLICY "admin_all_alert"         ON lgu_alert         FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_announcements" ON lgu_announcements FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_articles"      ON lgu_articles      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_events"        ON lgu_events        FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_gallery"       ON lgu_gallery       FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_hero"          ON lgu_hero_slides   FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_officials"     ON lgu_officials     FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_services"      ON lgu_services      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_documents"     ON lgu_documents     FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_barangays"     ON lgu_barangays     FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_directory"     ON lgu_directory     FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_faq"           ON lgu_faq           FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_settings"      ON lgu_settings      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_users"         ON lgu_users         FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_audit"         ON lgu_audit         FOR ALL USING (auth.role() = 'authenticated');

-- ═══════════════════════════════════════════════════════════════
--  AUTO-UPDATE TIMESTAMPS
-- ═══════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_articles_ts  BEFORE UPDATE ON lgu_articles  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_officials_ts BEFORE UPDATE ON lgu_officials FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_settings_ts  BEFORE UPDATE ON lgu_settings  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_users_ts     BEFORE UPDATE ON lgu_users     FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ═══════════════════════════════════════════════════════════════
--  STORAGE BUCKETS
--  Create these manually in Supabase Dashboard > Storage:
--
--  Bucket name   | Public | Purpose              | Max size
--  lgu-images    | YES    | Hero, gallery, photos| 5 MB
--  lgu-docs      | YES    | PDF documents        | 10 MB
--  lgu-logo      | YES    | Site logo            | 2 MB
-- ═══════════════════════════════════════════════════════════════
