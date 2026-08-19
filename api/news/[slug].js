// GET /news/:slug  (rewritten from vercel.json to this function)
//
// Generates a real, standalone, crawlable HTML page for a single
// article — proper <title>, meta description, and per-article Open
// Graph/Twitter Card tags (so sharing a specific article on Facebook/
// Messenger/X shows THAT article's headline and photo, not the site's
// generic homepage preview), plus the actual article text as plain
// HTML that search engines and social crawlers can read without
// running any JavaScript.
//
// Deliberately does NOT auto-redirect visitors into the JS single-page
// app — a page that only works via a JS redirect is exactly the
// "cloaking" pattern search engines penalize. This page is fully
// functional and readable on its own; it just also offers a link into
// the full interactive site for anyone who wants it.
//
// The :slug in the URL only needs to END in the article's numeric id
// (e.g. "some-headline-1712345678901") — the words before that are
// purely for a readable URL, not used for lookup, so old links never
// break even if the headline is edited later.

const SUPABASE_URL  = 'https://llybnlehnagtaghtaouj.supabase.co';
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxseWJubGVobmFndGFnaHRhb3VqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY1MzU4NzYsImV4cCI6MjEwMjExMTg3Nn0.6rRYJdxcmEbEsv_4Ki317_8MybMs6EqlGaRZapa_418';
const SITE_NAME = 'Municipality of Real — Quezon Province';
const SITE_URL  = 'https://lgu-real-quezon.vercel.app';
const DEFAULT_OG_IMAGE = SITE_URL + '/og-image.jpg';

function esc(s) {
  return String(s == null ? '' : s)
    .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
function stripHtml(html) {
  return String(html || '').replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim();
}
function formatDate(dateStr) {
  try {
    return new Date(dateStr + 'T00:00:00').toLocaleDateString('en-PH', { year: 'numeric', month: 'long', day: 'numeric' });
  } catch { return dateStr || ''; }
}

module.exports = async (req, res) => {
  const slug = (req.query.slug || '').toString();
  const idMatch = slug.match(/(\d+)$/);
  const id = idMatch ? idMatch[1] : slug;

  let article = null;
  try {
    const resp = await fetch(
      `${SUPABASE_URL}/rest/v1/lgu_kv?key=eq.lgu_articles&select=value`,
      { headers: { apikey: SUPABASE_ANON, Authorization: `Bearer ${SUPABASE_ANON}` } }
    );
    const rows = await resp.json();
    const articles = (rows && rows[0] && rows[0].value) || [];
    article = articles.find(a => String(a.id || '') === String(id) && a.published);
  } catch (err) {
    console.error('[news page] fetch failed', err);
  }

  if (!article) {
    res.statusCode = 404;
    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.end(`<!DOCTYPE html><html><head><meta charset="utf-8"><title>Article not found — ${esc(SITE_NAME)}</title></head>
      <body style="font-family:sans-serif;text-align:center;padding:80px 20px;">
        <h1>Article not found</h1>
        <p>This article may have been unpublished or removed.</p>
        <p><a href="${SITE_URL}/">← Back to the homepage</a></p>
      </body></html>`);
    return;
  }

  const title       = article.title || 'News Update';
  const summary     = article.summary || stripHtml(article.bodyHtml).slice(0, 200);
  const description = summary || `Read the latest from the ${SITE_NAME}.`;
  const image       = article.cover || DEFAULT_OG_IMAGE;
  const canonicalUrl = `${SITE_URL}/news/${slug}`;
  const spaUrl        = `${SITE_URL}/#article=${encodeURIComponent(article.id || article.title)}`;

  const html = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)} — ${esc(SITE_NAME)}</title>
<meta name="description" content="${esc(description)}">
<link rel="canonical" href="${esc(canonicalUrl)}">

<meta property="og:type" content="article">
<meta property="og:site_name" content="${esc(SITE_NAME)}">
<meta property="og:title" content="${esc(title)}">
<meta property="og:description" content="${esc(description)}">
<meta property="og:image" content="${esc(image)}">
<meta property="og:url" content="${esc(canonicalUrl)}">
${article.date ? `<meta property="article:published_time" content="${esc(article.date)}">` : ''}

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="${esc(title)}">
<meta name="twitter:description" content="${esc(description)}">
<meta name="twitter:image" content="${esc(image)}">

<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🏛️</text></svg>">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Inter', sans-serif; color: #2D3748; line-height: 1.7; background: #F5F0E8; }
  header { background: linear-gradient(180deg, #0F2419 0%, #1A3C2E 100%); padding: 18px 6%; }
  header a { color: white; text-decoration: none; font-family: 'Playfair Display', serif; font-weight: 700; font-size: 1.05rem; display: flex; align-items: center; gap: 10px; }
  main { max-width: 760px; margin: 0 auto; padding: 40px 6% 80px; }
  .cover { width: 100%; max-height: 380px; object-fit: cover; border-radius: 12px; display: block; margin-bottom: 28px; }
  .meta { font-size: 0.85rem; color: #718096; margin-bottom: 14px; }
  h1 { font-family: 'Playfair Display', serif; font-size: clamp(1.6rem, 4vw, 2.3rem); color: #0F2419; line-height: 1.2; margin-bottom: 20px; }
  .body { font-size: 1.05rem; color: #4A5568; }
  .body p { margin-bottom: 16px; }
  .body img { max-width: 100%; border-radius: 8px; margin: 16px 0; }
  .cta { margin-top: 48px; padding: 24px; background: white; border-radius: 12px; text-align: center; border: 1px solid #EAE5DB; }
  .cta a { display: inline-block; margin-top: 10px; background: #1A3C2E; color: white; padding: 12px 26px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 0.9rem; }
</style>
</head>
<body>
  <header><a href="${SITE_URL}/">🏛️ ${esc(SITE_NAME)}</a></header>
  <main>
    ${article.cover ? `<img class="cover" src="${esc(article.cover)}" alt="${esc(title)}">` : ''}
    <div class="meta">📅 ${esc(formatDate(article.date))}</div>
    <h1>${esc(title)}</h1>
    <div class="body">${article.bodyHtml || `<p>${esc(summary)}</p>`}</div>
    <div class="cta">
      <p>Visit the full municipal website for news, services, events, and more.</p>
      <a href="${esc(spaUrl)}">🏛️ Go to realquezon.gov.ph →</a>
    </div>
  </main>
</body>
</html>`;

  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.setHeader('Cache-Control', 'public, max-age=300, s-maxage=3600');
  res.end(html);
};
