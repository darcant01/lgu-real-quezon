// ============================================================
//  Supabase Admin API — LGU Real
//  All write operations for the admin panel
//  Requires a valid Supabase Auth session (JWT)
// ============================================================

// ── AUTH ─────────────────────────────────────────────────────

async function adminSignIn(email, password) {
  const { data, error } = await db.auth.signInWithPassword({ email, password });
  if (error) throw error;
  return data.session;
}

async function adminSignOut() {
  await logAudit('logout', 'Signed out', currentUser());
  await db.auth.signOut();
}

function currentUser() {
  // Returns user metadata stored in the JWT
  const session = db.auth.getSession();
  return session?.user?.user_metadata || null;
}

// ── SETTINGS ─────────────────────────────────────────────────

async function saveSetting(key, value) {
  const { error } = await db.from('lgu_settings').upsert({ key, value }, { onConflict: 'key' });
  if (error) throw error;
}

async function saveSettings(obj) {
  const rows = Object.entries(obj).map(([key, value]) => ({ key, value: String(value) }));
  const { error } = await db.from('lgu_settings').upsert(rows, { onConflict: 'key' });
  if (error) throw error;
}

// ── ANNOUNCEMENTS ─────────────────────────────────────────────

async function saveAnnouncements(list) {
  // Delete all then re-insert with fresh sort orders
  await db.from('lgu_announcements').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((a, i) => ({ text: a.text, active: a.active, sort_order: i }));
  const { error } = await db.from('lgu_announcements').insert(rows);
  if (error) throw error;
}

// ── ARTICLES ─────────────────────────────────────────────────

async function getAllArticles() {
  const { data, error } = await db.from('lgu_articles').select('*').order('created_at', { ascending: false });
  if (error) throw error;
  return data || [];
}

async function upsertArticle(article) {
  const row = {
    title:     article.title,
    tag:       article.tag,
    summary:   article.summary,
    body_html: article.bodyHtml || article.body_html,
    cover_url: article.coverUrl || article.cover_url || null,
    date:      article.date || null,
    published: article.published,
    author:    article.author || null,
    updated_at: new Date().toISOString(),
  };
  if (article.id) {
    const { error } = await db.from('lgu_articles').update(row).eq('id', article.id);
    if (error) throw error;
    return article.id;
  } else {
    const { data, error } = await db.from('lgu_articles').insert(row).select('id').single();
    if (error) throw error;
    return data.id;
  }
}

async function deleteArticle(id) {
  const { error } = await db.from('lgu_articles').delete().eq('id', id);
  if (error) throw error;
}

// ── EVENTS ───────────────────────────────────────────────────

async function saveEvents(list) {
  await db.from('lgu_events').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((e, i) => ({
    title: e.title, date: e.date || null, time: e.time || null,
    venue: e.venue || null, type: e.type || 'Other',
    description: e.description || null, active: e.active, sort_order: i
  }));
  const { error } = await db.from('lgu_events').insert(rows);
  if (error) throw error;
}

// ── GALLERY ──────────────────────────────────────────────────

async function getAllGallery() {
  const { data } = await db.from('lgu_gallery').select('*').order('sort_order');
  return data || [];
}

async function saveGalleryOrder(list) {
  // Update sort_order for each item and save captions
  for (let i = 0; i < list.length; i++) {
    await db.from('lgu_gallery').update({ sort_order: i, caption: list[i].caption }).eq('id', list[i].id);
  }
}

async function addGalleryItem(imageUrl, caption = '') {
  const { error } = await db.from('lgu_gallery').insert({ image_url: imageUrl, caption, sort_order: 999 });
  if (error) throw error;
}

async function deleteGalleryItem(id) {
  const { error } = await db.from('lgu_gallery').delete().eq('id', id);
  if (error) throw error;
}

// ── HERO SLIDES ───────────────────────────────────────────────

async function saveHeroSlides(list) {
  await db.from('lgu_hero_slides').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((s, i) => ({
    image_url: s.image_url || s.image, caption: s.caption || null,
    subtitle: s.subtitle || null, sort_order: i
  }));
  const { error } = await db.from('lgu_hero_slides').insert(rows);
  if (error) throw error;
}

// ── OFFICIALS ────────────────────────────────────────────────

async function saveOfficials(list) {
  await db.from('lgu_officials').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((o, i) => ({
    name: o.name || null, role: o.role || null, bio: o.bio || null,
    party: o.party || null, term: o.term || null, emoji: o.emoji || '🧑‍💼',
    photo_url: o.photo_url || o.photo || null, sort_order: i
  }));
  const { error } = await db.from('lgu_officials').insert(rows);
  if (error) throw error;
}

// ── SERVICES ─────────────────────────────────────────────────

async function saveServices(list) {
  await db.from('lgu_services').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((s, i) => ({
    icon: s.icon, title: s.title, description: s.desc || s.description,
    link: s.link || '#', arrow: s.arrow || 'Learn More', sort_order: i
  }));
  const { error } = await db.from('lgu_services').insert(rows);
  if (error) throw error;
}

// ── DOCUMENTS ─────────────────────────────────────────────────

async function saveDocuments(list) {
  await db.from('lgu_documents').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((d, i) => ({
    title: d.title, category: d.category, type: d.type,
    url: d.url, active: true, sort_order: i
  }));
  const { error } = await db.from('lgu_documents').insert(rows);
  if (error) throw error;
}

// ── BARANGAYS ────────────────────────────────────────────────

async function saveBarangays(list) {
  await db.from('lgu_barangays').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((b, i) => ({
    name: b.name, emoji: b.emoji || '🏘️', captain: b.captain || null,
    population: b.population || null, area: b.area || null,
    description: b.description || null, sort_order: i
  }));
  const { error } = await db.from('lgu_barangays').insert(rows);
  if (error) throw error;
}

// ── DIRECTORY ────────────────────────────────────────────────

async function saveDirectory(list) {
  await db.from('lgu_directory').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((d, i) => ({
    dept: d.dept || null, name: d.name, head: d.head || null,
    phone: d.phone || null, email: d.email || null,
    hours: d.hours || 'Mon–Fri, 8AM–5PM', sort_order: i
  }));
  const { error } = await db.from('lgu_directory').insert(rows);
  if (error) throw error;
}

// ── FAQ ───────────────────────────────────────────────────────

async function saveFAQ(list) {
  await db.from('lgu_faq').delete().neq('id', 0);
  if (!list.length) return;
  const rows = list.map((f, i) => ({ question: f.question, answer: f.answer, sort_order: i }));
  const { error } = await db.from('lgu_faq').insert(rows);
  if (error) throw error;
}

// ── ALERT ────────────────────────────────────────────────────

async function saveAlert(alert) {
  const { error } = await db.from('lgu_alert').upsert({
    id: 1, active: alert.active, title: alert.title, body: alert.body
  }, { onConflict: 'id' });
  if (error) throw error;
}

// ── USERS ────────────────────────────────────────────────────

async function getAdminUsers() {
  const { data, error } = await db.from('lgu_users').select('id,username,name,dept,role,mfa_enabled,active,force_pass_change,created_at');
  if (error) throw error;
  return data || [];
}

async function upsertAdminUser(user) {
  const row = {
    username:    user.username,
    name:        user.name || null,
    dept:        user.dept || null,
    role:        user.role,
    mfa_enabled: user.mfaEnabled || false,
    active:      user.active !== false,
    force_pass_change: user.forcePassChange || false,
  };
  if (user.passHash) row.pass_hash = user.passHash;
  if (user.id) {
    const { error } = await db.from('lgu_users').update(row).eq('id', user.id);
    if (error) throw error;
  } else {
    row.pass_hash = user.passHash;
    const { error } = await db.from('lgu_users').insert(row);
    if (error) throw error;
  }
}

async function deleteAdminUser(id) {
  const { error } = await db.from('lgu_users').delete().eq('id', id);
  if (error) throw error;
}

// ── AUDIT ────────────────────────────────────────────────────

async function getAuditLog(limit = 100, typeFilter = null) {
  let query = db.from('lgu_audit').select('*').order('created_at', { ascending: false }).limit(limit);
  if (typeFilter && typeFilter !== 'all') query = query.eq('type', typeFilter);
  const { data } = await query;
  return data || [];
}
