-- Query: Seed sample Citizen's Charter entries for demo purposes
-- Run this once in Supabase SQL Editor. You can edit/replace these
-- later through the Admin Panel — Citizen's Charter section.

INSERT INTO lgu_kv (key, value)
VALUES (
  'lgu_charter',
  $$[
    {
      "id": 1001,
      "title": "Business Permit Application (New)",
      "category": "Business",
      "office": "Business Permits and Licensing Office (BPLO)",
      "clients": "New business owners, entrepreneurs, corporations",
      "requirements": [
        "Barangay Business Clearance",
        "DTI Certificate of Registration (for sole proprietorship) or SEC Certificate (for corporation/partnership)",
        "Lease Contract or Certificate of Land/Building Ownership",
        "Locational Clearance / Zoning Clearance",
        "Fire Safety Inspection Certificate",
        "Sanitary Permit",
        "Community Tax Certificate (Cedula)",
        "2 valid government-issued IDs of the applicant"
      ],
      "steps": [
        { "action": "Submit application form and complete requirements at BPLO window", "duration": "10 mins", "fee": "Free" },
        { "action": "Assessment of applicable fees and taxes", "duration": "20 mins", "fee": "Free" },
        { "action": "Pay assessed fees at the Municipal Treasurer's Office", "duration": "15 mins", "fee": "Varies by business type & capital" },
        { "action": "Claim printed Business Permit and Official Receipt", "duration": "15 mins", "fee": "Free" }
      ],
      "totalDuration": "1 working day",
      "totalFee": "Varies by business type (see assessment)",
      "active": true,
      "updatedAt": "2026-08-12T00:00:00.000Z"
    },
    {
      "id": 1002,
      "title": "Business Permit Renewal",
      "category": "Business",
      "office": "Business Permits and Licensing Office (BPLO)",
      "clients": "Existing business owners renewing annually",
      "requirements": [
        "Previous year's Business Permit (original)",
        "Barangay Business Clearance (current year)",
        "Latest Income Statement or Certificate of Gross Sales",
        "Updated Fire Safety Inspection Certificate",
        "Updated Sanitary Permit",
        "Official Receipt of previous payment"
      ],
      "steps": [
        { "action": "Submit renewal application with requirements", "duration": "10 mins", "fee": "Free" },
        { "action": "Assessment based on gross sales/receipts", "duration": "20 mins", "fee": "Free" },
        { "action": "Pay renewal fees at Treasurer's Office", "duration": "15 mins", "fee": "Varies by gross sales" },
        { "action": "Claim renewed Business Permit", "duration": "10 mins", "fee": "Free" }
      ],
      "totalDuration": "1 working day",
      "totalFee": "Varies by gross sales (see assessment)",
      "active": true,
      "updatedAt": "2026-08-12T00:00:00.000Z"
    },
    {
      "id": 1003,
      "title": "Request for Certified True Copy of Birth Certificate",
      "category": "Civil Registry",
      "office": "Office of the Local Civil Registrar (LCRO)",
      "clients": "Any registered individual or authorized representative",
      "requirements": [
        "Duly accomplished Request Form",
        "1 valid government-issued ID of requesting party",
        "Authorization Letter and ID of registrant (if requested by representative)",
        "Proof of relationship (if requested by a relative)"
      ],
      "steps": [
        { "action": "Submit request form and requirements at LCRO window", "duration": "5 mins", "fee": "Free" },
        { "action": "Verification against civil registry records", "duration": "15 mins", "fee": "Free" },
        { "action": "Pay certification fee at Treasurer's Office", "duration": "10 mins", "fee": "₱95.00" },
        { "action": "Release of certified true copy", "duration": "10 mins", "fee": "Free" }
      ],
      "totalDuration": "40 minutes (same day)",
      "totalFee": "₱95.00",
      "active": true,
      "updatedAt": "2026-08-12T00:00:00.000Z"
    },
    {
      "id": 1004,
      "title": "Certificate of Indigency",
      "category": "Social Services",
      "office": "Municipal Social Welfare and Development Office (MSWDO)",
      "clients": "Low-income residents requesting financial or medical assistance eligibility",
      "requirements": [
        "Barangay Certificate of Indigency",
        "1 valid government-issued ID",
        "Proof of residency (utility bill or barangay certification)"
      ],
      "steps": [
        { "action": "Submit barangay certificate and ID at MSWDO", "duration": "5 mins", "fee": "Free" },
        { "action": "Interview and verification of eligibility", "duration": "15 mins", "fee": "Free" },
        { "action": "Preparation and signing of certificate", "duration": "15 mins", "fee": "Free" },
        { "action": "Release of Certificate of Indigency", "duration": "5 mins", "fee": "Free" }
      ],
      "totalDuration": "40 minutes (same day)",
      "totalFee": "Free",
      "active": true,
      "updatedAt": "2026-08-12T00:00:00.000Z"
    },
    {
      "id": 1005,
      "title": "Building Permit Application",
      "category": "Building & Permits",
      "office": "Office of the Municipal Engineer (OME)",
      "clients": "Property owners, contractors, developers",
      "requirements": [
        "Duly accomplished Building Permit Application Form",
        "Certified True Copy of Land Title or proof of property right",
        "Tax Declaration and current Real Property Tax Receipt",
        "5 sets of building plans signed by a licensed architect/engineer",
        "Structural design and specifications",
        "Bill of Materials and Cost Estimate",
        "Locational/Zoning Clearance",
        "Barangay Clearance"
      ],
      "steps": [
        { "action": "Submit application and complete documentary requirements", "duration": "20 mins", "fee": "Free" },
        { "action": "Technical evaluation of plans by Engineering staff", "duration": "3-5 working days", "fee": "Free" },
        { "action": "Assessment of building permit fees", "duration": "30 mins", "fee": "Based on floor area & project cost" },
        { "action": "Pay assessed fees at Treasurer's Office", "duration": "15 mins", "fee": "Varies by project" },
        { "action": "Release of approved Building Permit", "duration": "15 mins", "fee": "Free" }
      ],
      "totalDuration": "5-7 working days",
      "totalFee": "Varies by project size and cost",
      "active": true,
      "updatedAt": "2026-08-12T00:00:00.000Z"
    }
  ]$$::jsonb
)
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = NOW();
