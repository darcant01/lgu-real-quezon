# 🏛️ LGU Real — Deployment Guide
## Municipality of Real, Quezon Province

---

## 📁 What's in this ZIP

```
lgu-real/
├── public/
│   └── index.html          ← Your main public website
├── admin/
│   └── index.html          ← Your admin panel (staff only)
├── supabase/
│   └── migrations/
│       └── 001_schema.sql  ← Database tables + security rules
├── vercel.json             ← Hosting configuration
├── .gitignore              ← Files Git should ignore
└── DEPLOYMENT_GUIDE.md     ← This file
```

---

## 🔑 Default Admin Login

```
Username: admin
Password: Admin@Real2026!
```
> ⚠️ Change this immediately after your first login.

---

## STEP 1 — SUPABASE (Database)
**Time needed: ~15 minutes**

Supabase is your database. It stores all your content — announcements, articles, events, officials, etc.

### 1.1 — Create your account

1. Go to **[supabase.com](https://supabase.com)**
2. Click **Start your project** → sign up with GitHub or Google
3. Click **New Project**

### 1.2 — Create a new project

Fill in:
- **Organization:** your name or LGU Real
- **Project name:** `lgu-real`
- **Database password:** Create a strong password — **save this somewhere safe**
- **Region:** `Southeast Asia (Singapore)` — closest to Philippines
- Click **Create new project**
- ⏳ Wait about 2 minutes for it to finish

### 1.3 — Run the database setup

1. In the left sidebar, click **SQL Editor**
2. Click **+ New query** (top left)
3. Open the file `supabase/migrations/001_schema.sql` from this ZIP in any text editor (Notepad, VS Code, etc.)
4. **Select all** (Ctrl+A) and **copy** (Ctrl+C)
5. Paste into the Supabase SQL Editor
6. Click **Run** (or press Ctrl+Enter)
7. You should see: *"Success. No rows returned."*

### 1.4 — Create Storage Buckets (for images and PDFs)

1. In the left sidebar, click **Storage**
2. Click **New bucket** — create these **3 buckets** one by one:

| Bucket name   | Public bucket? | Description              |
|---------------|:--------------:|--------------------------|
| `lgu-images`  | ✅ YES         | Photos, gallery, officials |
| `lgu-docs`    | ✅ YES         | PDF documents, reports   |
| `lgu-logo`    | ✅ YES         | Municipal logo           |

For each bucket:
- Type the name
- Toggle **Public bucket** to ON
- Click **Save**

Then for each bucket, click the bucket → click **Policies** tab → click **New Policy** → choose **For full customization** → paste this and save:

```sql
-- Allow public to read (view images)
CREATE POLICY "public_read" ON storage.objects
  FOR SELECT USING (bucket_id IN ('lgu-images','lgu-docs','lgu-logo'));

-- Allow authenticated admins to upload
CREATE POLICY "admin_upload" ON storage.objects
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Allow authenticated admins to delete
CREATE POLICY "admin_delete" ON storage.objects
  FOR DELETE USING (auth.role() = 'authenticated');
```

### 1.5 — Get your API keys

1. In the left sidebar, click **Settings** (gear icon at the bottom)
2. Click **API**
3. Copy and save these two values:

```
Project URL:  https://xxxxxxxxxx.supabase.co
Anon key:     eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

> The anon key is safe to use in your website code. It only allows what your security rules permit.

### 1.6 — Paste your keys into the HTML files

Open **both** of these files in a text editor (Notepad, VS Code, etc.):
- `public/index.html`
- `admin/index.html`

In each file, find these two lines near the top (search for `YOUR_PROJECT_REF`):

```javascript
const SUPABASE_URL  = 'https://YOUR_PROJECT_REF.supabase.co';
const SUPABASE_ANON = 'YOUR_ANON_PUBLIC_KEY';
```

Replace with your actual values:

```javascript
const SUPABASE_URL  = 'https://abcdefghij.supabase.co';   // your Project URL
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6...'; // your Anon key
```

Save both files.

---

## STEP 2 — GITHUB (Version Control)
**Time needed: ~10 minutes**

GitHub stores your code and connects to Vercel for automatic deployment.

### 2.1 — Install Git (if you don't have it)

- **Windows:** Download from [git-scm.com](https://git-scm.com/download/win) → install with defaults
- **Mac:** Open Terminal and type `git --version` → it will prompt you to install
- Restart your computer after installing

### 2.2 — Create a GitHub account

1. Go to **[github.com](https://github.com)** → Sign up (free)
2. Verify your email

### 2.3 — Create a new repository

1. Click the **+** icon (top right) → **New repository**
2. Fill in:
   - **Repository name:** `lgu-real-quezon`
   - **Description:** `Official website — Municipality of Real, Quezon Province`
   - **Visibility:** `Private` ✅ (recommended for government)
   - **Do NOT** check "Add a README file"
3. Click **Create repository**
4. You'll see a page with setup instructions — **keep this page open**

### 2.4 — Upload your files

**Option A — Using GitHub Desktop (Easiest, no terminal needed):**

1. Download **[GitHub Desktop](https://desktop.github.com/)** and install it
2. Sign in with your GitHub account
3. Click **File → Add local repository** → navigate to your extracted ZIP folder
4. Click **Publish repository** → choose your `lgu-real-quezon` repo
5. Click **Publish repository** — done!

**Option B — Using the terminal:**

Open Terminal (Mac/Linux) or Command Prompt (Windows), navigate to your folder:

```bash
# Navigate to your project folder
cd path/to/lgu-real

# Initialize git
git init

# Add all files
git add .

# Save with a message
git commit -m "Initial commit — LGU Real website"

# Connect to GitHub (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/lgu-real-quezon.git

# Push to GitHub
git branch -M main
git push -u origin main
```

When prompted, enter your GitHub username and password.

> ⚠️ If GitHub asks for a "personal access token" instead of a password:
> Go to GitHub → Settings → Developer settings → Personal access tokens → Generate new token (classic) → check "repo" → copy and use that as your password.

---

## STEP 3 — VERCEL (Hosting)
**Time needed: ~5 minutes**

Vercel hosts your website and gives it a public URL. It automatically re-deploys whenever you push to GitHub.

### 3.1 — Create a Vercel account

1. Go to **[vercel.com](https://vercel.com)**
2. Click **Sign Up** → choose **Continue with GitHub** (use the same GitHub account)
3. Authorize Vercel

### 3.2 — Import your project

1. Click **Add New…** → **Project**
2. Find `lgu-real-quezon` in the list → click **Import**
3. Configure the project:
   - **Framework Preset:** `Other`
   - **Root Directory:** leave blank (or `.`)
   - **Build Command:** leave blank
   - **Output Directory:** `public`
4. Click **Deploy**
5. ⏳ Wait about 30–60 seconds

### 3.3 — Your site is live! 🎉

Vercel gives you a URL like: `https://lgu-real-quezon.vercel.app`

- Public site: `https://lgu-real-quezon.vercel.app`
- Admin panel: `https://lgu-real-quezon.vercel.app/admin`

### 3.4 — Set up a custom domain (Optional)

If you have an official domain like `realquezon.gov.ph`:

1. In Vercel, go to your project → **Settings** → **Domains**
2. Type your domain → click **Add**
3. Vercel will show you DNS records to add
4. Log in to your domain registrar (where you bought the domain)
5. Add the DNS records Vercel shows you
6. Wait up to 24 hours for the domain to go live

---

## STEP 4 — TEST EVERYTHING

After deployment, test these:

- [ ] Visit your public URL — homepage loads
- [ ] Click **🔐 Admin** → login popup appears
- [ ] Login with `admin` / `Admin@Real2026!`
- [ ] Admin panel opens
- [ ] Go to **Settings → Change Password** → change the default password
- [ ] Add an announcement → check it appears on the public site
- [ ] Upload a gallery photo → check it appears on the public site

---

## STEP 5 — UPDATING YOUR SITE

**Content updates** (articles, events, officials, etc.):
- Just use the admin panel at `/admin` — no code changes needed

**Code updates** (design, features):
1. Edit your HTML files locally
2. Open GitHub Desktop → write a commit message → **Commit to main** → **Push origin**
3. Vercel automatically re-deploys in ~30 seconds

---

## 🔒 Security Reminders

- [ ] Change the default admin password immediately
- [ ] Keep your Supabase service role key secret (never put it in HTML files)
- [ ] Keep your GitHub repo **Private**
- [ ] The admin URL (`/admin`) is not indexed by search engines (already configured)
- [ ] Regularly export the Audit Trail from the admin panel → **Audit Trail → Export CSV**

---

## ❓ Common Problems

**"Site not loading" after Vercel deploy:**
Check the Vercel deployment logs. Usually means a file path issue — make sure `vercel.json` is in the root folder.

**"Cannot connect to Supabase" in admin:**
Double-check you replaced `YOUR_PROJECT_REF` and `YOUR_ANON_PUBLIC_KEY` in both HTML files. Copy the exact values from Supabase Dashboard → Settings → API.

**"RLS policy error" when saving:**
Make sure you ran the full `001_schema.sql` file in Supabase SQL Editor.

**Images not uploading:**
Make sure your Storage buckets (`lgu-images`, `lgu-docs`, `lgu-logo`) are set to **Public** in Supabase Storage.

**Supabase project paused:**
Free Supabase projects pause after 1 week of inactivity. Go to [supabase.com](https://supabase.com) → your project → click **Restore**. For a production government site, consider the **Pro plan** ($25/month).

---

## 📞 Tech Stack Summary

| What           | Tool      | Cost  |
|----------------|-----------|-------|
| Code storage   | GitHub    | Free  |
| Database       | Supabase  | Free* |
| Image storage  | Supabase  | Free* |
| Website hosting| Vercel    | Free* |
| Domain name    | Your registrar | ~₱800/year |

*Free tiers are sufficient for a municipality website. If traffic grows, Supabase Pro is $25/month and Vercel Pro is $20/month.

---

*Built for Municipality of Real, Quezon Province, Philippines 🇵🇭*
