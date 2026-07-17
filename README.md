# 🏛️ LGU Real, Quezon Province — Official Website

A full-featured government website with a secure admin panel for the Municipality of Real, Quezon Province, Philippines.

---

## 🗂️ Project Structure

```
lgu-real/
├── public/                   ← Public-facing website
│   ├── index.html            ← Main site (lgu-real-quezon.html → rename this)
│   └── supabase-client.js    ← Shared Supabase client & data fetchers
├── admin/                    ← Admin panel (staff only)
│   ├── index.html            ← Admin panel (lgu-admin.html → rename this)
│   └── supabase-admin.js     ← Admin write operations
├── supabase/
│   └── migrations/
│       └── 001_schema.sql    ← Full database schema + RLS policies
├── vercel.json               ← Vercel deployment config
├── .env.example              ← Environment variable template
└── README.md                 ← This file
```

---

## 🚀 Deployment Guide

### Step 1 — GitHub

1. Create a new repository on [github.com](https://github.com/new)
   - Name: `lgu-real-quezon` (or your preferred name)
   - Set to **Private** (recommended for government sites)
   - Do NOT add a README (you already have one)

2. Push your files:
```bash
cd lgu-real
git init
git add .
git commit -m "Initial commit — LGU Real website"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/lgu-real-quezon.git
git push -u origin main
```

3. Add `.gitignore`:
```
.env.local
.env
node_modules/
.vercel/
```

---

### Step 2 — Supabase

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Click **New Project**
   - Organization: your LGU organization (or personal)
   - Project name: `lgu-real`
   - Database password: use a strong password (save it!)
   - Region: **Southeast Asia (Singapore)** — closest to the Philippines
   - Click **Create new project** and wait ~2 minutes

3. **Run the database schema:**
   - Go to **SQL Editor** (left sidebar)
   - Click **New Query**
   - Paste the entire contents of `supabase/migrations/001_schema.sql`
   - Click **Run** (or press Ctrl+Enter)
   - You should see "Success. No rows returned."

4. **Create Storage Buckets:**
   - Go to **Storage** (left sidebar)
   - Click **New bucket** and create these three:

   | Bucket name   | Public | Max file size |
   |---------------|--------|---------------|
   | `lgu-images`  | ✅ Yes | 5 MB          |
   | `lgu-docs`    | ✅ Yes | 10 MB         |
   | `lgu-logo`    | ✅ Yes | 2 MB          |

   For each bucket, go to **Policies** and add:
   - SELECT: `true` (anyone can read)
   - INSERT: `auth.role() = 'authenticated'` (only logged-in admins can upload)
   - DELETE: `auth.role() = 'authenticated'`

5. **Get your API keys:**
   - Go to **Settings > API**
   - Copy the **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - Copy the **anon public key** (safe to expose in frontend code)

6. **Set up Authentication:**
   - Go to **Authentication > Providers**
   - Email provider is enabled by default — keep it on
   - Go to **Authentication > Users**
   - Click **Invite user** and create the first Super Admin account
   - **Important:** after they sign in, run this SQL to set their role:
   ```sql
   -- Replace the email with your admin's email
   UPDATE auth.users
   SET raw_user_meta_data = raw_user_meta_data || '{"user_role": "super"}'
   WHERE email = 'your-admin@example.com';
   ```

---

### Step 3 — Update the HTML files

Before deploying, update the two HTML files with your Supabase credentials.

**In `public/index.html`** — find this near the top of the `<script>` section and replace:
```html
<!-- ADD BEFORE YOUR CLOSING </head> TAG -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script>
  window.SUPABASE_URL  = 'https://YOUR_PROJECT_REF.supabase.co';
  window.SUPABASE_ANON = 'YOUR_ANON_KEY';
</script>
<script src="/supabase-client.js"></script>
```

**In `admin/index.html`** — same, plus include the admin helper:
```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script>
  window.SUPABASE_URL  = 'https://YOUR_PROJECT_REF.supabase.co';
  window.SUPABASE_ANON = 'YOUR_ANON_KEY';
</script>
<script src="/supabase-client.js"></script>
<script src="/admin/supabase-admin.js"></script>
```

> 💡 The anon key is safe to put in frontend code — Supabase's Row Level Security
> controls what it can actually read or write. Never put the service_role key here.

---

### Step 4 — Vercel

1. Go to [vercel.com](https://vercel.com) and sign in with GitHub
2. Click **Add New > Project**
3. Import your `lgu-real-quezon` repository
4. Configure:
   - **Framework Preset:** Other
   - **Root Directory:** leave as `/`
   - **Build Command:** leave blank (static site)
   - **Output Directory:** leave as `public`

5. **Add Environment Variables** (optional — if you want to use them server-side):
   - `NEXT_PUBLIC_SUPABASE_URL` → your Project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` → your anon key

6. Click **Deploy** and wait ~30 seconds

7. Your site is live at: `https://lgu-real-quezon.vercel.app`

8. **Set up a custom domain** (optional):
   - Go to your Vercel project > **Settings > Domains**
   - Add `realquezon.gov.ph` (or your official domain)
   - Follow the DNS instructions to point your domain to Vercel

---

## 🔐 Security Checklist

Before going live:

- [ ] RLS policies are active on all Supabase tables ✅ (done by schema)
- [ ] Storage buckets require auth to upload ✅ (set in Step 2)
- [ ] Admin panel URL is `/admin/` — not linked from public nav (except the login modal)
- [ ] `vercel.json` adds `X-Robots-Tag: noindex` to `/admin/` ✅
- [ ] First Super Admin has changed their temporary password
- [ ] Service role key is NOT in any frontend file
- [ ] GitHub repo is set to **Private**

---

## 🔄 Updating the Site

After deployment, all content is managed through the admin panel at:
`https://your-domain.com/admin/`

No code changes or redeployment needed for:
- News articles, announcements, events
- Officials, barangay profiles, directory
- Gallery, hero images, documents
- FAQ, services, alert banner

For code changes (layout, design, features):
```bash
git add .
git commit -m "describe your change"
git push
# Vercel auto-deploys in ~30 seconds
```

---

## 📞 Tech Stack

| Layer       | Technology            | Purpose                        |
|-------------|-----------------------|--------------------------------|
| Frontend    | Vanilla HTML/CSS/JS   | Fast, no build step needed     |
| Database    | Supabase (PostgreSQL) | All content, RLS security      |
| File Storage| Supabase Storage      | Images, PDFs, logos            |
| Auth        | Supabase Auth         | Admin login, JWT sessions      |
| Hosting     | Vercel                | CDN, SSL, custom domain        |
| Version Control | GitHub            | Code history, auto-deploy      |

---

## 🆘 Common Issues

**"RLS policy violation" error when saving from admin**
→ Make sure you're signed in to Supabase Auth and your JWT has the correct `user_role` metadata. Run the SQL in Step 2.6 again.

**Images not showing after upload**
→ Check that the Storage bucket is set to **Public** and the SELECT policy is `true`.

**Admin panel not found at /admin/**
→ Make sure `vercel.json` is in the root of your repository and the route is configured.

**Supabase project paused (free plan)**
→ Free Supabase projects pause after 1 week of inactivity. Go to the Supabase dashboard and click **Restore project**. Consider upgrading to Pro ($25/month) for a production government site.

---

*Built for Municipality of Real, Quezon Province, Philippines. 🇵🇭*
