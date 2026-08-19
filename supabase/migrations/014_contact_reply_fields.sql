-- Query: Adds columns to store the actual reply sent from admin, so
-- there's a record of what was said and when — not just a "replied"
-- status flag.
-- Run in Supabase → SQL Editor → New Query → Run. Safe to re-run.

ALTER TABLE lgu_contact_messages ADD COLUMN IF NOT EXISTS reply_text TEXT;
ALTER TABLE lgu_contact_messages ADD COLUMN IF NOT EXISTS replied_at TIMESTAMPTZ;
ALTER TABLE lgu_contact_messages ADD COLUMN IF NOT EXISTS replied_by TEXT;
