# Local Email Testing with Mailpit

## Overview

Mailpit is a local email testing tool (like Mailgun but runs on your machine). It captures all emails sent by your application and provides a web interface to view them.

## Quick Start

1. **Start Mailpit** (already added to docker-compose.dev.yml):
   ```bash
   docker-compose -f docker-compose.dev.yml up -d mailpit
   ```

2. **Configure .env for local testing:**
   ```bash
   # Add to your .env file
   SMTP_HOST=mailpit  # Use service name in Docker, or localhost if running outside Docker
   SMTP_PORT=1025
   SMTP_USER=          # Leave empty (no auth needed)
   SMTP_PASS=          # Leave empty (no auth needed)
   EMAIL_FROM_ADDR=noreply@earniqa.local
   EMAIL_FROM_NAME=Earniqa
   ```

3. **Restart access-worker:**
   ```bash
   docker-compose -f docker-compose.dev.yml restart access-worker
   ```

4. **View emails:**
   - Open http://localhost:8025 in your browser
   - All sent emails will appear here
   - You can view HTML/text content, headers, attachments, etc.

## Configuration Details

### For Docker Services (Recommended)
Since access-worker runs in Docker and Mailpit is also in Docker, use the service name:

```bash
SMTP_HOST=mailpit  # Service name from docker-compose
SMTP_PORT=1025
SMTP_USER=         # Empty - no authentication
SMTP_PASS=         # Empty - no authentication
EMAIL_FROM_ADDR=noreply@earniqa.local
EMAIL_FROM_NAME=Earniqa
```

### For Local Development (Outside Docker)
If you're running services locally (not in Docker):

```bash
SMTP_HOST=localhost
SMTP_PORT=1025
SMTP_USER=
SMTP_PASS=
EMAIL_FROM_ADDR=noreply@earniqa.local
EMAIL_FROM_NAME=Earniqa
```

## Testing

1. Make a test payment as a member
2. Check access-worker logs:
   ```bash
   docker-compose -f docker-compose.dev.yml logs -f access-worker | grep -i email
   ```
3. Open http://localhost:8025 to see the email
4. Click on any email to view full content, headers, HTML/text, etc.

## Mailpit Features

- ✅ **Web UI**: Beautiful interface at http://localhost:8025
- ✅ **No Authentication**: Simple setup, no credentials needed
- ✅ **Email Capture**: All emails are stored and viewable
- ✅ **HTML/Text View**: View rendered HTML and plain text versions
- ✅ **Headers**: See all email headers
- ✅ **Search**: Search through sent emails
- ✅ **Auto-refresh**: Real-time updates when new emails arrive

## Production vs Development

- **Development**: Use Mailpit (local testing)
- **Production**: Use real SMTP (Gmail, SendGrid, Mailgun, AWS SES, etc.)

Just update your `.env` file when switching environments!

## Troubleshooting

### Mailpit not accessible
```bash
# Check if Mailpit is running
docker-compose -f docker-compose.dev.yml ps mailpit

# Check Mailpit logs
docker-compose -f docker-compose.dev.yml logs mailpit

# Restart Mailpit
docker-compose -f docker-compose.dev.yml restart mailpit
```

### Emails not appearing
1. Verify SMTP configuration:
   ```bash
   docker-compose -f docker-compose.dev.yml exec access-worker env | grep SMTP
   ```
2. Check access-worker logs for errors:
   ```bash
   docker-compose -f docker-compose.dev.yml logs access-worker | grep -i email
   ```
3. Make sure Mailpit is running and accessible from access-worker container

### Connection refused
If using `SMTP_HOST=mailpit`, make sure:
- Mailpit service is running in the same Docker network
- Access-worker is also in the same network (they are by default)
- Service name matches exactly: `mailpit`

