-- ═══════════════════════════════════════════════════════════════
--  LGU REAL, QUEZON — PITCH DEMO SEED DATA (CORRECTED)
--  Targets the actual lgu_kv key-value table the live site reads from.
--  Run in Supabase → SQL Editor → New Query → Run.
--  Safe to re-run — each key is upserted, not duplicated.
-- ═══════════════════════════════════════════════════════════════

INSERT INTO lgu_kv (key, value) VALUES

('lgu_barangays', '[
  {"name":"Poblacion I","emoji":"🏛️","captain":"Hon. Ramon D. Santos","population":"6,023","area":"412 ha","description":"The seat of the municipal government, home to the Municipal Hall, public market, and St. Raphael the Archangel Parish."},
  {"name":"Poblacion 61","emoji":"🏘️","captain":"Hon. Teresa M. Villareal","population":"2,647","area":"380 ha","description":"A densely populated urban barangay adjoining the town center, known for its commercial strip and transport terminals."},
  {"name":"Ungos","emoji":"⛴️","captain":"Hon. Ricardo P. Fajardo","population":"4,234","area":"298 ha","description":"Coastal barangay and home to Ungos Port, the main gateway for inter-island transport to Polillo and nearby islands."},
  {"name":"Tignoan","emoji":"🌊","captain":"Hon. Marilou C. Espino","population":"3,971","area":"341 ha","description":"A coastal community known for its fishing industry and stretches of beach frequented by local surfers."},
  {"name":"Llavac","emoji":"💧","captain":"Hon. Danilo S. Reyes","population":"3,828","area":"733 ha","description":"An upland barangay home to Tipuan Falls, a multi-tiered waterfall reached by a scenic hiking trail."},
  {"name":"Cawayan","emoji":"🎋","captain":"Hon. Fe Aurora L. Manalo","population":"2,450","area":"401 ha","description":"An agricultural barangay along the Cawayan River, primarily engaged in coconut and rice farming."},
  {"name":"Kiloloran","emoji":"🌾","captain":"Hon. Bienvenido T. Cruz","population":"2,498","area":"403 ha","description":"A rural farming community and one of the fastest-growing barangays in the municipality."},
  {"name":"Poblacion (Capalong)","emoji":"🏡","captain":"Hon. Salvador M. Ilagan","population":"2,049","area":"411 ha","description":"A residential barangay bordering the Poblacion, with a mix of agricultural and residential land use."},
  {"name":"Maragondon","emoji":"🌴","captain":"Hon. Cristina B. Alvarez","population":"2,233","area":"389 ha","description":"A quiet farming barangay known for coconut plantations and small-scale copra production."},
  {"name":"Lubayat","emoji":"⛰️","captain":"Hon. Armando G. Torres","population":"1,914","area":"512 ha","description":"An upland barangay at the foothills of the Sierra Madre, with growing agri-tourism potential."},
  {"name":"Pandan","emoji":"🌳","captain":"Hon. Josefina R. Domingo","population":"1,389","area":"287 ha","description":"A rural barangay named after the native pandan plants that once thrived along its riverbanks."},
  {"name":"Malapad","emoji":"💦","captain":"Hon. Eduardo N. Bautista","population":"1,295","area":"498 ha","description":"Home to the scenic Balagbag Falls, a two-tiered waterfall and one of Real''s top eco-tourism sites."},
  {"name":"Tanauan","emoji":"🌊","captain":"Hon. Corazon P. Delos Santos","population":"1,886","area":"276 ha","description":"A coastal barangay with small fishing communities along Lamon Bay."},
  {"name":"Maunlad","emoji":"🌱","captain":"Hon. Rodel A. Marasigan","population":"796","area":"198 ha","description":"A small but progressive barangay known locally for its community-based livelihood programs."},
  {"name":"Tagumpay","emoji":"🎯","captain":"Hon. Leonora V. Castillo","population":"279","area":"134 ha","description":"One of the smallest barangays by population, primarily agricultural."},
  {"name":"Bagong Silang","emoji":"🌅","captain":"Hon. Alfredo J. Ramos","population":"910","area":"211 ha","description":"A resettlement-origin barangay that has since grown into a stable residential community."},
  {"name":"Masikap","emoji":"💪","captain":"Hon. Perla D. Aquino","population":"276","area":"112 ha","description":"A small upland barangay whose name means \"industrious\" — reflecting its farming community."}
]'),

('lgu_officials', '[
  {"name":"Hon. Julie Ann O. Macasaet","role":"Municipal Mayor","bio":"Leads the Municipality of Real with a focus on transparent governance, disaster resilience, and digital transformation of public services.","party":"Independent","term":"2022–2025","emoji":"👩‍💼"},
  {"name":"Hon. Diana Abigail Diestro-Aquino","role":"Municipal Vice Mayor","bio":"Presides over the Sangguniang Bayan and champions legislative reforms supporting barangay development and youth programs.","party":"Independent","term":"2022–2025","emoji":"🧑‍💼"},
  {"name":"Hon. Jenra Asis-Poblete","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Health and actively supports maternal and child health initiatives across all 17 barangays.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Ronald Isidro","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Infrastructure, overseeing farm-to-market road and flood-control projects.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Kayzie Atendido","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Education, working closely with DepEd Real District on school facility improvements.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Michelle Avanica","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Women and Family, leading gender and development (GAD) programs.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Darius Castro","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Agriculture and Fisheries, supporting coconut and fishery livelihood programs.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Seth Almonte","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Tourism, promoting Balagbag Falls, Tipuan Falls, and Real''s coastal attractions.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Amelie Peñamante","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Environment, leading coastal clean-up and reforestation drives.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Lea Calleja","role":"Sangguniang Bayan Member","bio":"Chairs the Committee on Youth and Sports Development, working with the SK Federation.","party":"Independent","term":"2022–2025","emoji":"🧑‍⚖️"},
  {"name":"Hon. Mark Anthony Villaflor","role":"SK Federation President","bio":"Represents the youth sector in the Sangguniang Bayan and leads youth livelihood and leadership programs.","party":"Independent","term":"2023–2026","emoji":"🧑‍🎓"}
]'),

('lgu_directory', '[
  {"dept":"Executive","name":"Office of the Municipal Mayor","head":"Hon. Julie Ann O. Macasaet","phone":"(042) 205-1001","email":"mayor@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Legislative","name":"Office of the Sangguniang Bayan","head":"Hon. Diana Abigail Diestro-Aquino","phone":"(042) 205-1002","email":"sb@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Civil Registry","name":"Municipal Civil Registrar''s Office","head":"Ms. Corazon P. Ilagan","phone":"(042) 205-1010","email":"civilregistry@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Planning","name":"Municipal Planning and Development Office","head":"Engr. Roberto S. Manalo","phone":"(042) 205-1011","email":"mpdo@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Treasury","name":"Office of the Municipal Treasurer","head":"Ms. Angelica V. Fernandez","phone":"(042) 205-1012","email":"treasury@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Health","name":"Municipal Health Office","head":"Dr. Ferdinand L. Ocampo","phone":"(042) 205-1013","email":"health@realquezon.gov.ph","hours":"Mon–Sat, 8AM–5PM"},
  {"dept":"Social Welfare","name":"Municipal Social Welfare and Development Office","head":"Ms. Leah B. Santiago","phone":"(042) 205-1014","email":"mswdo@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Engineering","name":"Office of the Municipal Engineer","head":"Engr. Paolo D. Ramirez","phone":"(042) 205-1015","email":"engineering@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Agriculture","name":"Municipal Agriculture Office","head":"Mr. Vicente A. Torres","phone":"(042) 205-1016","email":"agriculture@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Environment","name":"Municipal Environment and Natural Resources Office","head":"Ms. Rosanna T. Delos Reyes","phone":"(042) 205-1017","email":"menro@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"DRRM","name":"Municipal Disaster Risk Reduction and Management Office","head":"Mr. Julius C. Bautista","phone":"(042) 205-1018 / 0917-000-1234","email":"mdrrmo@realquezon.gov.ph","hours":"24/7 (Emergency Hotline)"},
  {"dept":"Business Permits","name":"Business Permits and Licensing Office","head":"Ms. Grace N. Villamor","phone":"(042) 205-1019","email":"bplo@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"},
  {"dept":"Tourism","name":"Municipal Tourism Office","head":"Mr. Ariel J. Domingo","phone":"(042) 205-1020","email":"tourism@realquezon.gov.ph","hours":"Mon–Fri, 8AM–5PM"}
]'),

('lgu_services', '[
  {"icon":"📄","title":"Civil Registry","desc":"Request birth, marriage, and death certificates, and file civil registration documents.","link":"#directory","arrow":"Learn More"},
  {"icon":"🏗️","title":"Building Permits","desc":"Apply for building, occupancy, and fencing permits for residential and commercial construction.","link":"#directory","arrow":"Learn More"},
  {"icon":"🏪","title":"Business Licensing","desc":"Register a new business or renew your Mayor''s Permit through the Business One-Stop Shop.","link":"#directory","arrow":"Learn More"},
  {"icon":"🏥","title":"Health Services","desc":"Access free consultations, immunizations, and maternal health programs at the Municipal Health Office.","link":"#directory","arrow":"Learn More"},
  {"icon":"🤝","title":"Social Welfare","desc":"Avail of assistance programs for senior citizens, PWDs, solo parents, and indigent families.","link":"#directory","arrow":"Learn More"},
  {"icon":"📜","title":"Certifications","desc":"Request barangay clearance, indigency certificates, and residency certifications.","link":"#directory","arrow":"Learn More"},
  {"icon":"🌳","title":"Environmental Office","desc":"Report environmental concerns and apply for tree-cutting or land-clearing permits.","link":"#directory","arrow":"Learn More"},
  {"icon":"💰","title":"Real Property Tax","desc":"Check your real property assessment and payment history, or visit the Treasurer''s Office to pay.","link":"#directory","arrow":"Learn More"}
]'),

('lgu_faq', '[
  {"question":"What are the requirements for a business permit renewal?","answer":"Bring your previous year''s Mayor''s Permit, updated Barangay Clearance, proof of tax payment, and your latest Financial Statement or Sworn Declaration of Gross Sales. Renewal period is every January."},
  {"question":"How do I request a copy of my birth certificate?","answer":"Visit the Municipal Civil Registrar''s Office with a valid ID and payment for the certification fee. Processing typically takes 1–3 working days for local records; PSA-authenticated copies take longer."},
  {"question":"Where can I pay my real property tax?","answer":"Payments are accepted at the Office of the Municipal Treasurer, Municipal Hall, Poblacion I. Bring your latest Tax Declaration or Official Receipt for reference."},
  {"question":"How do I apply for a building permit?","answer":"Submit building plans signed and sealed by a licensed engineer or architect, lot title or tax declaration, barangay clearance, and other requirements to the Office of the Municipal Engineer."},
  {"question":"Who do I contact during a typhoon or emergency?","answer":"Contact the Municipal Disaster Risk Reduction and Management Office (MDRRMO) hotline at 0917-000-1234, available 24/7. Emergency alerts are also posted on this website''s homepage banner."},
  {"question":"How can I avail of senior citizen or PWD benefits?","answer":"Register at the Municipal Social Welfare and Development Office (MSWDO) with a valid ID, proof of age or disability, and barangay certification. First-time registrants receive an OSCA/PWD ID."}
]'),

('lgu_events', '[
  {"title":"Real Town Fiesta — Feast of St. Raphael the Archangel","date":"2026-10-24","time":"8:00 AM","venue":"Poblacion I, Municipal Plaza","type":"Festival","description":"Annual town fiesta featuring a grand parade, cultural presentations, and evening fireworks display.","active":true},
  {"title":"Free Medical & Dental Mission","date":"2026-09-05","time":"7:00 AM","venue":"Real Municipal Gymnasium","type":"Health","description":"Free check-ups, dental extractions, and medicine distribution in partnership with the Provincial Health Office.","active":true},
  {"title":"Sangguniang Bayan Regular Session","date":"2026-08-25","time":"9:00 AM","venue":"SB Session Hall, Municipal Hall","type":"Meeting","description":"Regular monthly session open to the public. Agenda posted 3 days prior at the Municipal Hall bulletin board.","active":true},
  {"title":"Barangay Officials Capacity Building Training","date":"2026-09-15","time":"8:00 AM","venue":"Real Municipal Gymnasium","type":"Training","description":"DILG-led training for all 17 barangay captains and councils on governance and disaster preparedness.","active":true},
  {"title":"Coastal Clean-Up Drive — Ungos & Tignoan","date":"2026-09-20","time":"6:00 AM","venue":"Ungos Port and Tignoan Beach","type":"Civic","description":"Joint clean-up activity with MENRO, youth volunteers, and barangay officials in observance of Coastal Clean-Up Month.","active":true}
]'),

('lgu_articles', '[
  {"id":"1","title":"Municipality of Real Launches Official Website and Digital Services Portal","tag":"news","summary":"Real, Quezon becomes one of the first 3rd-class municipalities in the province to launch a full digital government website with an integrated content management system.","date":"2026-08-10","published":true},
  {"id":"2","title":"MDRRMO Conducts Pre-Emptive Evacuation Drill Ahead of Rainy Season","tag":"health","summary":"Barangay officials and residents from coastal barangays participated in a coordinated evacuation simulation.","date":"2026-07-28","published":true},
  {"id":"3","title":"Real Farmers Receive Free Seedlings Under DA Livelihood Program","tag":"infrastructure","summary":"Over 200 farmers from Cawayan, Kiloloran, and Lubayat received free coconut and vegetable seedlings.","date":"2026-07-15","published":true}
]'),

('lgu_announcements', '[
  {"text":"📢 Business Permit Renewal period is ongoing until January 20 — visit BPLO for assistance.","active":true},
  {"text":"🏥 Free Medical & Dental Mission on September 5 at the Real Municipal Gymnasium.","active":true},
  {"text":"🌊 Coastal Clean-Up Drive volunteers needed — sign up at the Tourism Office.","active":true},
  {"text":"📄 Civil Registry now processing PSA-authenticated documents within 5–7 working days.","active":true}
]'),

('lgu_documents', '[
  {"title":"2026 Annual Budget","category":"Budget","type":"PDF","url":"#"},
  {"title":"Citizen''s Charter 2026","category":"FOI","type":"PDF","url":"#"},
  {"title":"SB Resolution No. 2026-045 — Website Authorization","category":"Resolutions","type":"PDF","url":"#"},
  {"title":"Municipal Ordinance No. 2025-12 — Environmental Code","category":"Ordinances","type":"PDF","url":"#"},
  {"title":"Bids and Awards Committee — Q3 2026 Notice of Award","category":"Bid & Awards","type":"PDF","url":"#"},
  {"title":"2025 Annual Accomplishment Report","category":"Annual Reports","type":"PDF","url":"#"},
  {"title":"Full Disclosure Policy — Q2 2026","category":"Transparency Seal","type":"PDF","url":"#"}
]'),

('lgu_programs', '[
  {"icon":"🌊","title":"Coastal Resource Management","desc":"Protecting Real''s marine sanctuaries, coral reef systems, and fish landing areas through community-led conservation efforts and ordinance enforcement.","status":"Ongoing"},
  {"icon":"🌱","title":"Sierra Madre Greening Program","desc":"Reforestation and watershed rehabilitation along the municipality''s mountainous interior, partnering with DENR and indigenous peoples groups.","status":"Ongoing"},
  {"icon":"🛣️","title":"Farm-to-Market Roads","desc":"Improving road access from upland barangays to the municipal center, reducing post-harvest losses and boosting local agricultural trade.","status":"Ongoing"},
  {"icon":"🏘️","title":"Resettlement & Housing","desc":"Safe housing relocation for families in hazard-prone coastal and riverine areas, with the support of NHA and DILG.","status":"New 2026"},
  {"icon":"⚡","title":"Solar Street Lighting","desc":"Installing solar-powered street lights in all 17 barangays to improve nighttime safety and reduce the municipal electricity budget.","status":"New 2026"},
  {"icon":"🐟","title":"Livelihood & Fisheries","desc":"Boat assistance, fishing gear provisioning, and livelihood training programs for artisanal fishing households along Real''s coastline.","status":"Ongoing"}
]'),

('lgu_alert', '{"active":false,"title":"","body":""}'),

('lgu_settings', '{"name":"Municipality of Real","province":"Quezon Province"}')

ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = NOW();

-- ═══════════════════════════════════════════════════════════════
--  DONE. Hard-refresh your live site (Ctrl+Shift+R) — all sections
--  should now populate.
-- ═══════════════════════════════════════════════════════════════
