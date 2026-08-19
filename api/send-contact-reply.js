// POST /api/send-contact-reply
// Sends a real reply email (via Gmail SMTP) to the person who submitted
// a Contact form message, triggered from inside the admin panel — no
// need to leave the admin panel or use a personal email client.
//
// Security: requires the admin's own Supabase Auth access token
// (Authorization: Bearer <jwt>), the same one their browser session
// already holds from logging in. This function builds a Supabase
// client authenticated AS that user (not a service-role bypass), so
// every action here only ever has the permissions Supabase Auth
// actually grants an authenticated admin — never more. Someone without
// a valid, current admin session gets rejected outright.
//
// Requires GMAIL_USER and GMAIL_APP_PASSWORD in the Vercel project
// (same ones used by notify-contact-message.js — see api/_lib/mailer.js
// for details). SUPABASE_URL should already be set from earlier setup.

const { createClient } = require('@supabase/supabase-js');
const { sendMail } = require('./_lib/mailer');

// Public anon key — safe to embed, it's the same one used client-side
// throughout this app. What makes this request privileged is the
// admin's own JWT forwarded in the Authorization header, not this key.
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxseWJubGVobmFndGFnaHRhb3VqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY1MzU4NzYsImV4cCI6MjEwMjExMTg3Nn0.6rRYJdxcmEbEsv_4Ki317_8MybMs6EqlGaRZapa_418';

function esc(s) {
  return String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const supabaseUrl = process.env.SUPABASE_URL;
  if (!supabaseUrl || !process.env.GMAIL_USER || !process.env.GMAIL_APP_PASSWORD) {
    res.status(500).json({ error: 'Server not configured — missing SUPABASE_URL, GMAIL_USER, or GMAIL_APP_PASSWORD' });
    return;
  }

  const authHeader = req.headers.authorization || '';
  const jwt = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : '';
  if (!jwt) {
    res.status(401).json({ error: 'Missing authorization — please log in again' });
    return;
  }

  let body = req.body;
  if (typeof body === 'string') { try { body = JSON.parse(body); } catch { body = {}; } }
  const { id, replyText } = body || {};
  if (!id || !replyText || !replyText.trim()) {
    res.status(400).json({ error: 'Missing message id or reply text' });
    return;
  }

  // Authenticated AS the admin — RLS applies exactly as it would for
  // them in the browser, not a privileged bypass.
  const supabase = createClient(supabaseUrl, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });

  const { data: userData, error: userErr } = await supabase.auth.getUser(jwt);
  if (userErr || !userData || !userData.user) {
    res.status(401).json({ error: 'Invalid or expired session — please log in again' });
    return;
  }

  const { data: msg, error: msgErr } = await supabase
    .from('lgu_contact_messages')
    .select('*')
    .eq('id', id)
    .maybeSingle();
  if (msgErr || !msg) {
    res.status(404).json({ error: 'Message not found' });
    return;
  }
  if (!msg.email) {
    res.status(400).json({ error: 'This message has no email address to reply to' });
    return;
  }

  const name = [msg.first_name, msg.last_name].filter(Boolean).join(' ') || 'Resident';
  const html = `
    <div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;">
      <p>Dear ${esc(name)},</p>
      <p>Thank you for reaching out to the Municipality of Real. Here is our response to your inquiry:</p>
      <p style="background:#F5F0E8;padding:14px 18px;border-radius:8px;white-space:pre-wrap;">${esc(replyText)}</p>
      ${msg.message ? `<p style="color:#718096;font-size:0.85rem;margin-top:20px;"><strong>Your original message:</strong><br>${esc(msg.message)}</p>` : ''}
      <p style="margin-top:24px;">Municipality of Real, Quezon Province</p>
    </div>`;

  try {
    await sendMail({
      to: msg.email,
      subject: `Re: ${msg.subject || 'Your inquiry to the Municipality of Real'}`,
      html,
    });
  } catch (err) {
    console.error('[send-contact-reply]', err);
    res.status(502).json({ error: err.message || 'Failed to send email' });
    return;
  }

  await supabase.from('lgu_contact_messages').update({
    status: 'replied',
    reply_text: replyText,
    replied_at: new Date().toISOString(),
    replied_by: userData.user.email || userData.user.id,
  }).eq('id', id);

  res.status(200).json({ sent: true });
};
