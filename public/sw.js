// Minimal service worker — exists mainly to satisfy PWA "installability"
// criteria (Chrome requires a registered fetch handler). This site's
// content is database-driven via Supabase, so we deliberately do NOT
// cache pages or API responses — that would show visitors stale content.
// Only a handful of small static assets (icons/manifest) are pre-cached,
// purely as an offline fallback if the network request fails.

const CACHE_NAME = 'lgu-real-shell-v1';
const PRECACHE_URLS = ['/manifest.json', '/icon-192.png', '/icon-512.png'];

self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(PRECACHE_URLS))
      .catch(() => {}) // don't block install if a precache asset fails
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

// Network-first for everything: always try to get fresh content, and only
// fall back to the small precached shell if the network request fails
// (e.g. offline).
self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request))
  );
});

// ── EMERGENCY ALERT PUSH NOTIFICATIONS ──────────────────────────
// Fired when the backend (api/send-alert-push.js) sends a push after an
// admin activates an Emergency Alert. Shows a system notification even
// if the site isn't open — this is what makes "installed" devices get
// alerted without the app being open. The OS/browser plays its own
// default notification sound automatically; a custom in-page sound
// effect additionally plays if a tab of the site happens to be open
// (see the 'message' broadcast below and loadAlert() in index.html).
self.addEventListener('push', (event) => {
  let data = {};
  try { data = event.data ? event.data.json() : {}; } catch { data = {}; }
  const title = data.title || 'Emergency Alert — Municipality of Real';
  const options = {
    body: data.body || '',
    icon: '/icon-192.png',
    badge: '/icon-192.png',
    vibrate: [250, 120, 250, 120, 250],
    tag: 'lgu-emergency-alert',
    renotify: true,
    requireInteraction: true,
    data: { url: data.url || '/' },
  };
  event.waitUntil((async () => {
    await self.registration.showNotification(title, options);
    // Let any open tab know a push just arrived, so it can play the
    // custom alert sound too (native notifications can't carry a custom
    // sound file across browsers, so this covers the "app open" case).
    const clientsList = await self.clients.matchAll({ type: 'window' });
    clientsList.forEach((client) => client.postMessage({ type: 'lgu-alert-push', title, body: data.body || '' }));
  })());
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = (event.notification.data && event.notification.data.url) || '/';
  event.waitUntil((async () => {
    const clientsList = await self.clients.matchAll({ type: 'window' });
    const existing = clientsList.find((c) => c.url.includes(self.location.origin));
    if (existing) { existing.focus(); return; }
    await self.clients.openWindow(url);
  })());
});
