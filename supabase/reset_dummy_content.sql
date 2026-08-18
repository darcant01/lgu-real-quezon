-- ═══════════════════════════════════════════════════════════════
--  RESET — clears the dummy Tourism / About Us content back to empty
--  Run in Supabase → SQL Editor → New Query → Run.
--
--  Only clears the exact keys the dummy content script added.
--  Everything else on your site (barangays, officials, services,
--  events, articles, programs, etc.) is untouched.
-- ═══════════════════════════════════════════════════════════════

UPDATE lgu_kv SET value = '[]'::jsonb              WHERE key = 'lgu_attractions';
UPDATE lgu_kv SET value = '{"body":""}'::jsonb      WHERE key = 'lgu_tourism_itinerary';
UPDATE lgu_kv SET value = '{"body":""}'::jsonb      WHERE key = 'lgu_tourism_tips';
UPDATE lgu_kv SET value = '{"body":""}'::jsonb      WHERE key = 'lgu_history';
UPDATE lgu_kv SET value = '{"body":""}'::jsonb      WHERE key = 'lgu_mission_vision';
UPDATE lgu_kv SET value = '{"body":""}'::jsonb      WHERE key = 'lgu_mandates';
UPDATE lgu_kv SET value = '{"body":""}'::jsonb      WHERE key = 'lgu_gad';

-- ═══════════════════════════════════════════════════════════════
--  DONE. Hard-refresh your live site — Tourism attractions and all
--  4 About Us pages should show their empty/"coming soon" states again.
-- ═══════════════════════════════════════════════════════════════
