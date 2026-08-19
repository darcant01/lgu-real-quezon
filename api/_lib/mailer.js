// Shared Gmail SMTP sender, used by both api/notify-contact-message.js
// and api/send-contact-reply.js.
//
// Uses a Gmail "App Password", not the real account password — a
// 16-character password generated specifically for this, so the real
// Google account credentials are never stored anywhere. Requires
// 2-Step Verification to be turned on for the Gmail account first
// (Google won't let you generate an App Password without it).
//
// Works the same whether GMAIL_USER is a personal @gmail.com address
// or a Google Workspace address on the municipality's own domain
// (e.g. info@realquezon.gov.ph) — Workspace is the better choice for
// official use, since replies then come from a real, recognizable
// municipal address instead of a personal Gmail.

const nodemailer = require('nodemailer');

function getTransport() {
  if (!process.env.GMAIL_USER || !process.env.GMAIL_APP_PASSWORD) {
    throw new Error('Missing GMAIL_USER or GMAIL_APP_PASSWORD environment variable');
  }
  return nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.GMAIL_USER,
      pass: process.env.GMAIL_APP_PASSWORD,
    },
  });
}

async function sendMail({ to, subject, html, replyTo }) {
  const transport = getTransport();
  const fromName = process.env.GMAIL_FROM_NAME || 'Municipality of Real';
  await transport.sendMail({
    from: `"${fromName}" <${process.env.GMAIL_USER}>`,
    to,
    subject,
    html,
    replyTo: replyTo || undefined,
  });
}

module.exports = { sendMail };
