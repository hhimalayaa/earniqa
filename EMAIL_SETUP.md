# Email/SMTP Configuration Guide

## Overview
Earniqa sends automatic emails to members after successful payments. These emails contain access links to join VIP channels (Telegram, Discord, etc.).

## Local Development Testing

For local development, use **Mailpit** (local email testing tool):

```bash
# Add to .env file
SMTP_HOST=mailpit  # Service name in Docker
SMTP_PORT=1025
SMTP_USER=         # Leave empty
SMTP_PASS=         # Leave empty
EMAIL_FROM_ADDR=noreply@earniqa.local
EMAIL_FROM_NAME=Earniqa
```

Then start Mailpit:
```bash
docker-compose -f docker-compose.dev.yml up -d mailpit
```

View emails at: **http://localhost:8025**

📄 See [LOCAL_EMAIL_TESTING.md](./LOCAL_EMAIL_TESTING.md) for detailed instructions.

---

## Production Configuration

For production, use a real SMTP provider:

## Required Configuration

Add the following environment variables to your `.env` file:

```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
EMAIL_FROM_ADDR=noreply@earniqa.com
EMAIL_FROM_NAME=Earniqa
```

## Common SMTP Providers

### Gmail
```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password  # Generate from Google Account → Security → App Passwords
```

**Note:** For Gmail, you need to:
1. Enable 2-Factor Authentication
2. Generate an "App Password" (not your regular password)
3. Use the app password in `SMTP_PASS`

### SendGrid
```bash
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=your-sendgrid-api-key
EMAIL_FROM_ADDR=verified-sender@yourdomain.com
```

### Mailgun
```bash
SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_USER=postmaster@yourdomain.mailgun.org
SMTP_PASS=your-mailgun-password
EMAIL_FROM_ADDR=noreply@yourdomain.com
```

### AWS SES
```bash
SMTP_HOST=email-smtp.us-east-1.amazonaws.com  # Use your region
SMTP_PORT=587
SMTP_USER=your-ses-smtp-username
SMTP_PASS=your-ses-smtp-password
EMAIL_FROM_ADDR=verified-email@yourdomain.com
```

## Testing

After configuring SMTP, restart the access-worker:

```bash
docker-compose -f docker-compose.dev.yml restart access-worker
```

Then check the logs to verify emails are being sent:

```bash
docker-compose -f docker-compose.dev.yml logs -f access-worker | grep -i email
```

## What Emails Are Sent?

1. **Member Access Email** - Sent automatically after successful payment
   - Contains access token for Telegram bot
   - Contains join links for Discord, WhatsApp, Slack channels
   - Includes instructions for joining VIP channels

## Troubleshooting

### Emails Not Being Sent

1. **Check SMTP Configuration:**
   ```bash
   docker-compose -f docker-compose.dev.yml exec access-worker env | grep SMTP
   ```

2. **Check Logs:**
   ```bash
   docker-compose -f docker-compose.dev.yml logs access-worker | grep -i email
   ```

3. **Verify Environment Variables:**
   - Make sure `.env` file exists and contains SMTP variables
   - Restart access-worker after changing `.env`

### Common Issues

- **Gmail "Less Secure Apps" Error:** Use App Password instead of regular password
- **Connection Timeout:** Check firewall/SMTP port (587 or 465)
- **Authentication Failed:** Verify SMTP_USER and SMTP_PASS are correct
- **Sender Not Verified (SES):** Verify sender email address in AWS SES

