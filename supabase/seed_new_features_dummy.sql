-- ═══════════════════════════════════════════════════════════════
--  DUMMY CONTENT — Tourism & About Us pages
--  Run in Supabase → SQL Editor → New Query → Run.
--  Fills in sections added after the original pitch seed script:
--  Attractions, Itinerary, Travel Tips, Brief History, Mission &
--  Vision, Mandates, GAD Corner. Safe to re-run.
--
--  NOTE: Awards & Recognition is intentionally left empty here —
--  those are factual claims about specific recognitions the LGU has
--  actually received, so fabricated award names would be misleading
--  in front of the Sangguniang Bayan. Fill that one in with real data
--  via admin → Awards whenever you have it.
-- ═══════════════════════════════════════════════════════════════

INSERT INTO lgu_kv (key, value) VALUES

('lgu_attractions', '[
  {"icon":"💦","name":"Balagbag Falls","category":"Waterfalls","description":"A two-tiered waterfall in Barangay Malapad. The lower tier is around 20 feet high and cascades into a moderately deep catch basin; the upper tier is roughly 100 feet but with a shallower basin. Stone steps carved into the rock lead up to the second tier for those wanting a closer look, though the climb can be slippery after rain.","photo":""},
  {"icon":"💧","name":"Tipuan Falls","category":"Waterfalls","description":"A multi-tiered waterfall in Barangay Llavac, reached via a scenic hiking trail through upland forest. A popular day-trip destination for local hikers and picnickers.","photo":""},
  {"icon":"⛴️","name":"Ungos Port","category":"Ports & Islands","description":"The municipality''s main sea gateway, providing inter-island transport to Polillo and other nearby islands. Also a working fishing port with fresh catch available in the early morning.","photo":""},
  {"icon":"🏖️","name":"Tignoan Beach","category":"Beaches","description":"A coastal stretch known locally for its fishing community and waves that draw surfers from nearby towns, especially during the amihan season.","photo":""}
]'),

('lgu_tourism_itinerary', '{"body":"<p><strong>Day 1 — Waterfalls & Nature</strong><br>Morning hike to Tipuan Falls in Barangay Llavac. Afternoon visit to Balagbag Falls in Barangay Malapad — bring water shoes, the rocks can be slippery.</p><p><strong>Day 2 — Coast & Culture</strong><br>Sunrise at Tignoan Beach, followed by a stop at Ungos Port to see the morning catch come in. Afternoon at the Municipal Hall area to see the heritage sites around Poblacion I.</p><p>Both routes can be done as a day trip from Lucena City or combined into a relaxed weekend stay.</p>"}'),

('lgu_tourism_tips', '{"body":"<p>Best time to visit is during the dry season, November to May, when trails and waterfall access are safest.</p><p>Jeepneys and vans bound for Real leave regularly from Lucena City Grand Terminal — travel time is approximately 2 hours depending on the route.</p><p>Bring cash — most local eateries and tricycle drivers do not accept cards. ATMs are limited to the town proper.</p><p>For waterfall visits, wear closed footwear with good grip and avoid the climb immediately after heavy rain.</p>"}'),

('lgu_history', '{"body":"<p>The Municipality of Real was established in 1901 along the eastern coast of Quezon Province, at the foot of the Sierra Madre mountain range facing the Pacific Ocean. Its location made it an early gateway for trade and travel along Luzon''s eastern seaboard.</p><p>Over the decades, Real grew from a small fishing and farming settlement into a diversified local economy built on agriculture, fisheries, and — more recently — ecotourism, drawing on its waterfalls, coastline, and upland forests.</p><p>Today, the municipality is composed of 17 barangays, each contributing to a local economy anchored in coconut and rice farming, coastal fishing, and small-scale trade.</p>"}'),

('lgu_mission_vision', '{"body":"<p><strong>Vision</strong><br>A progressive, disaster-resilient, and environmentally sustainable municipality where every resident has access to responsive public service, inclusive economic opportunity, and a safe, well-governed community.</p><p><strong>Mission</strong><br>To deliver transparent, efficient, and accountable local governance; to protect and sustainably manage Real''s natural resources — from the Sierra Madre watershed to the Pacific coastline; and to empower every barangay through equitable access to basic services, livelihood support, and disaster preparedness.</p>"}'),

('lgu_mandates', '{"body":"<p>As a municipal local government unit, Real operates under the mandate of the <strong>Local Government Code of 1991 (Republic Act No. 7160)</strong>, which grants municipalities autonomy over local governance, revenue generation, and the delivery of basic services including health, social welfare, agricultural extension, and public infrastructure.</p><p>The municipality likewise adheres to national mandates relevant to local governance, including the <strong>Ease of Doing Business and Efficient Government Service Delivery Act (RA 11032)</strong>, the <strong>Government Procurement Reform Act (RA 9184)</strong>, and the <strong>Philippine Disaster Risk Reduction and Management Act (RA 10121)</strong>, which guides the Municipal Disaster Risk Reduction and Management Office''s programs.</p><p>These mandates form the legal basis for the transparency, procurement, and disaster-preparedness initiatives administered by the Municipality of Real.</p>"}'),

('lgu_gad', '{"body":"<p>The Gender and Development (GAD) program of the Municipality of Real works to ensure equal access to opportunities, services, and protection for women, men, and vulnerable sectors across all 17 barangays, in line with the <strong>Magna Carta of Women (RA 9710)</strong>.</p><p>Current focus areas include maternal and reproductive health support, livelihood training for women-led households, protection services for survivors of violence, and gender-responsive planning across municipal programs and budgets.</p><p>Residents seeking GAD-related assistance may coordinate with the Municipal Social Welfare and Development Office (MSWDO).</p>"}')

ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = NOW();

-- ═══════════════════════════════════════════════════════════════
--  DONE. Hard-refresh your live site — Tourism attractions/itinerary/
--  tips and all 4 About Us pages should now show real-looking content
--  instead of placeholders.
-- ═══════════════════════════════════════════════════════════════
