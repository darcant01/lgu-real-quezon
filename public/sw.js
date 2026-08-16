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
