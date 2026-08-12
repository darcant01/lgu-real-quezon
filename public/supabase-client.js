// ============================================================
//  Supabase Client — LGU Real, Quezon Province
//  Used by both public site and admin panel
// ============================================================

// ── CONFIG ───────────────────────────────────────────────────
// These values come from your Supabase project dashboard:
// Settings > API > Project URL & Project API Keys
const SUPABASE_URL  = window.SUPABASE_URL  || '__SUPABASE_URL__';
const SUPABASE_ANON = window.SUPABASE_ANON || '__SUPABASE_ANON_KEY__';

// Load Supabase JS v2 from CDN (already included in HTML via <script> tag)
const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_ANON);

// ── PUBLIC DATA FETCHERS ──────────────────────────────────────
// These use the anon key and only return data allowed by RLS policies

async function getAnnouncements() {
  const { data } = await db.from('lgu_announcements').select('*').eq('active', true).order('sort_order');
  return data || [];
}

async function getPublishedArticles(limit = 3) {
  const { data } = await db.from('lgu_articles').select('id,title,tag,summary,cover_url,date,published').eq('published', true).order('created_at', { ascending: false }).limit(limit);
  return data || [];
}

async function getArticleById(id) {
  const { data } = await db.from('lgu_articles').select('*').eq('id', id).single();
  return data;
}

async function getUpcomingEvents() {
  const today = new Date().toISOString().slice(0, 10);
  const { data } = await db.from('lgu_events').select('*').eq('active', true).gte('date', today).order('date');
  return data || [];
}

async function getGallery() {
  const { data } = await db.from('lgu_gallery').select('*').order('sort_order');
  return data || [];
}

async function getHeroSlides() {
  const { data } = await db.from('lgu_hero_slides').select('*').order('sort_order');
  return data || [];
}

async function getOfficials() {
  const { data } = await db.from('lgu_officials').select('*').order('sort_order');
  return data || [];
}

async function getServices() {
  const { data } = await db.from('lgu_services').select('*').order('sort_order');
  return data || [];
}

async function getDocuments() {
  const { data } = await db.from('lgu_documents').select('*').eq('active', true).order('category').order('sort_order');
  return data || [];
}

async function getBarangays() {
  const { data } = await db.from('lgu_barangays').select('*').order('sort_order');
  return data || [];
}

async function getDirectory() {
  const { data } = await db.from('lgu_directory').select('*').order('sort_order');
  return data || [];
}

async function getFAQ() {
  const { data } = await db.from('lgu_faq').select('*').order('sort_order');
  return data || [];
}

async function getAlert() {
  const { data } = await db.from('lgu_alert').select('*').eq('id', 1).single();
  return data;
}

async function getSetting(key) {
  const { data } = await db.from('lgu_settings').select('value').eq('key', key).single();
  return data ? data.value : null;
}

async function getAllSettings() {
  const { data } = await db.from('lgu_settings').select('*');
  if (!data) return {};
  return Object.fromEntries(data.map(r => [r.key, r.value]));
}

// ── IMAGE URL HELPERS ─────────────────────────────────────────
// Get a public URL for a file in Supabase Storage

function getImageUrl(bucket, path) {
  if (!path) return '';
  if (path.startsWith('http')) return path; // already a full URL
  const { data } = db.storage.from(bucket).getPublicUrl(path);
  return data.publicUrl;
}

// ── FILE SIZE LIMITS ──────────────────────────────────────────
const FILE_LIMITS = {
  'lgu-images': 5  * 1024 * 1024,  // 5 MB
  'lgu-docs':   10 * 1024 * 1024,  // 10 MB
  'lgu-logo':   2  * 1024 * 1024,  // 2 MB
};

// ── UPLOAD HELPER ─────────────────────────────────────────────
async function uploadFile(bucket, file, folder = '') {
  const limit = FILE_LIMITS[bucket];
  if (limit && file.size > limit) {
    const mb = (limit / 1024 / 1024).toFixed(0);
    throw new Error(`File too large. Maximum size for this bucket is ${mb} MB.`);
  }
  const ext  = file.name.split('.').pop().toLowerCase();
  const name = `${folder}${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
  const { data, error } = await db.storage.from(bucket).upload(name, file, {
    cacheControl: '3600',
    upsert: false
  });
  if (error) throw error;
  return getImageUrl(bucket, data.path);
}

// ── AUDIT LOG HELPER ──────────────────────────────────────────
async function logAudit(type, action, user) {
  await db.from('lgu_audit').insert({
    type,
    action,
    username:  user?.username  || 'system',
    user_name: user?.name      || user?.username || 'System',
    user_role: user?.role      || '—',
  });
}

// ── AUTH HELPERS ──────────────────────────────────────────────
async function getSession() {
  const { data: { session } } = await db.auth.getSession();
  return session;
}

async function signOut() {
  await db.auth.signOut();
}
