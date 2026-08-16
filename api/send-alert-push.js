// POST /api/send-alert-push
// Sends a Web Push notification (title + body) to every subscribed
// browser when the admin activates an Emergency Alert.
//
// Requires these environment variables to be set in the Vercel project
// (Settings → Environment Variables), NOT committed to the repo:
//   VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY   — from `npx web-push generate-vapid-keys`
//   SUPABASE_URL                          — same project URL used by the app
//   SUPABASE_SERVICE_ROLE_KEY             — Supabase → Settings → API → service_role key
//                                            (secret; bypasses RLS — never expose client-side)
//   PUSH_TRIGGER_SECRET                   — any random string you choose; the admin panel
//                                            must send the same value in the
//                                            X-Push-Secret header for this to accept the request

const webpush = require('web-push');
const { createClient } = require('@supabase/supabase-js');

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const secret = req.headers['x-push-secret'];
  if (!process.env.PUSH_TRIGGER_SECRET || secret !== process.env.PUSH_TRIGGER_SECRET) {
    res.status(401).json({ error: 'Unauthorized' });
    return;
  }

  const requiredEnv = ['VAPID_PUBLIC_KEY', 'VAPID_PRIVATE_KEY', 'SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY'];
  const missing = requiredEnv.filter(k => !process.env[k]);
  if (missing.length) {
    res.status(500).json({ error: `Server not configured — missing env vars: ${missing.join(', ')}` });
    return;
  }

  let body = req.body;
  if (typeof body === 'string') { try { body = JSON.parse(body); } catch { body = {}; } }
  const title = (body && body.title) ? String(body.title).slice(0, 120) : 'Emergency Alert — Municipality of Real';
  const message = (body && body.body) ? String(body.body).slice(0, 500) : '';

  webpush.setVapidDetails(
    'mailto:info@realquezon.gov.ph',
    process.env.VAPID_PUBLIC_KEY,
    process.env.VAPID_PRIVATE_KEY
  );

  const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
  const { data: subs, error } = await supabase.from('lgu_push_subscriptions').select('*');
  if (error) {
    res.status(500).json({ error: error.message });
    return;
  }
  if (!subs || !subs.length) {
    res.status(200).json({ sent: 0, note: 'No subscribers yet' });
    return;
  }

  const payload = JSON.stringify({ title, body: message, url: '/' });
  const results = await Promise.allSettled(subs.map(async (s) => {
    try {
      await webpush.sendNotification(
        { endpoint: s.endpoint, keys: { p256dh: s.p256dh, auth: s.auth } },
        payload
      );
    } catch (err) {
      // Subscription no longer valid (browser uninstalled/reset it) — clean it up
      if (err.statusCode === 410 || err.statusCode === 404) {
        await supabase.from('lgu_push_subscriptions').delete().eq('endpoint', s.endpoint);
      }
      throw err;
    }
  }));

  const sent = results.filter(r => r.status === 'fulfilled').length;
  const failed = results.length - sent;
  res.status(200).json({ sent, failed, total: subs.length });
};
