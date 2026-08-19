-- Query: Adds a notify_token column so the email-notification flow
-- doesn't need the anonymous public role to read back its own insert
-- (which the existing RLS policies correctly don't allow — only an
-- authenticated admin session can SELECT from this table).
-- Run in Supabase → SQL Editor → New Query → Run. Safe to re-run.
--
-- The client generates a random token and includes it when inserting
-- its own message, then passes that same token (which it already
-- knows — no read-back needed) to the notify-contact-message API,
-- which looks the row up by token using the service role key.

ALTER TABLE lgu_contact_messages ADD COLUMN IF NOT EXISTS notify_token TEXT;

CREATE INDEX IF NOT EXISTS lgu_contact_messages_notify_token_idx
  ON lgu_contact_messages (notify_token);
