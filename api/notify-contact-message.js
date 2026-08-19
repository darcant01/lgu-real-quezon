// POST /api/notify-contact-message
// Sends an email notification to LGU staff whenever someone submits
// the public Contact form.
//
// Deliberately takes only a random lookup token from the client, not
// the actual name/email/message content — the client-supplied content
// isn't trusted. Instead this function re-fetches the real,
// already-saved row from the database itself (using the Supabase
// service role key, which bypasses the "only an authenticated admin
// can read this table" RLS policy on lgu_contact_messages) before
// sending anything. A token (rather than the row's own id) is used
// specifically because the anonymous public role that submits the
// form isn't allowed to read anything back from this table either —
// the token is generated client-side and never needs to be read back,
// only matched against server-side.
//
// Requires these environment variables in the Vercel project (Settings
// → Environment Variables) — SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY
// already exist from the push-notification setup; only RESEND_API_KEY
// is new:
//   RESEND_API_KEY            — from resend.com (free tier is plenty
//                                for a small LGU's contact form volume)
//   SUPABASE_URL               — same Supabase project URL used elsewhere
//   SUPABASE_SERVICE_ROLE_KEY  — same service role key used by send-alert-push

const { createClient } = require('@supabase/supabase-js');

function esc(s) {
  return String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const requiredEnv = ['RESEND_API_KEY', 'SUPABASE_URL', 'SUPABASE_SERVICE_ROLE_KEY'];
  const missing = requiredEnv.filter(k => !process.env[k]);
  if (missing.length) {
    // Fail quietly from the client's perspective — the contact message
    // itself was already saved successfully; this is just a "best
    // effort" extra notification, not something that should look like
    // an error to the person who submitted the form.
    res.status(200).json({ sent: false, reason: `Not configured: missing ${missing.join(', ')}` });
    return;
  }

  let body = req.body;
  if (typeof body === 'string') { try { body = JSON.parse(body); } catch { body = {}; } }
  const token = body && body.token;
  if (!token) {
    res.status(400).json({ error: 'Missing token' });
    return;
  }

  const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

  const { data: msg, error: msgErr } = await supabase
    .from('lgu_contact_messages')
    .select('*')
    .eq('notify_token', token)
    .maybeSingle();

  if (msgErr || !msg) {
    res.status(200).json({ sent: false, reason: 'Message not found' });
    return;
  }

  const { data: settingsRow } = await supabase
    .from('lgu_kv')
    .select('value')
    .eq('key', 'lgu_settings')
    .maybeSingle();
  const toEmail = (settingsRow && settingsRow.value && settingsRow.value.email) || null;

  if (!toEmail) {
    res.status(200).json({ sent: false, reason: 'No notification email set in admin → Settings → Site Information' });
    return;
  }

  const name = [msg.first_name, msg.last_name].filter(Boolean).join(' ') || '(no name given)';
  const html = `
    <div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;">
      <h2 style="color:#1A3C2E;">New Contact Form Message</h2>
      <p><strong>From:</strong> ${esc(name)}</p>
      <p><strong>Email:</strong> ${esc(msg.email || 'not provided')}</p>
      ${msg.barangay ? `<p><strong>Barangay:</strong> ${esc(msg.barangay)}</p>` : ''}
      ${msg.subject ? `<p><strong>Subject:</strong> ${esc(msg.subject)}</p>` : ''}
      <p><strong>Message:</strong></p>
      <p style="background:#F5F0E8;padding:14px 18px;border-radius:8px;white-space:pre-wrap;">${esc(msg.message)}</p>
      <p style="color:#718096;font-size:0.85rem;margin-top:24px;">Reply to this message from the admin panel → Messages, or reply directly to ${esc(msg.email || 'the sender')}.</p>
    </div>`;

  try {
    const resendResp = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: 'LGU Real Website <onboarding@resend.dev>',
        to: [toEmail],
        reply_to: msg.email || undefined,
        subject: `New Contact Form Message — ${name}`,
        html,
      }),
    });
    const result = await resendResp.json();
    if (!resendResp.ok) {
      console.error('[notify-contact-message] Resend error', result);
      res.status(200).json({ sent: false, reason: result.message || 'Resend API error' });
      return;
    }
    res.status(200).json({ sent: true });
  } catch (err) {
    console.error('[notify-contact-message]', err);
    res.status(200).json({ sent: false, reason: 'Network error sending email' });
  }
};
