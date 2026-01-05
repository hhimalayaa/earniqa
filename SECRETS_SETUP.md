# Secrets Management

This project uses environment variables for sensitive configuration values to avoid committing secrets to Git.

## Setup

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` and fill in your actual values:**
   ```bash
   # Use your favorite editor
   nano .env
   # or
   vim .env
   ```

3. **Important:** The `.env` file is gitignored and should never be committed to Git.

## Required Secrets

### Stripe Configuration
- `STRIPE_CONNECT_CLIENT_ID` - Your Stripe Connect client ID
- `STRIPE_WEBHOOK_SECRET` - Your Stripe webhook secret
- `STRIPE_SECRET_KEY` - Your Stripe secret key (test or live)
- `STRIPE_CONNECT_REDIRECT` - Your Stripe Connect redirect URL
- `STRIPE_PRICE_PRIME_MONTH` - Stripe Price ID for Prime monthly plan (e.g., `price_xxxxx`)
- `STRIPE_PRICE_PRO_MONTH` - Stripe Price ID for Pro monthly plan (e.g., `price_xxxxx`)
  
  **To get Price IDs:** Go to Stripe Dashboard → Products → Select your product → Copy the Price ID

### Telegram Configuration
- `TELEGRAM_BOT_TOKEN` - Your Telegram bot token from @BotFather

### Email/SMTP Configuration (Required for Member Access Emails)
- `SMTP_HOST` - SMTP server hostname (e.g., `smtp.gmail.com`, `smtp.sendgrid.net`)
- `SMTP_PORT` - SMTP server port (e.g., `587` for TLS, `465` for SSL)
- `SMTP_USER` - SMTP username (usually your email address)
- `SMTP_PASS` - SMTP password or app-specific password
- `EMAIL_FROM_ADDR` - Email address to send from (e.g., `noreply@earniqa.com`)
- `EMAIL_FROM_NAME` - Display name for sender (e.g., `Earniqa`)

**Note:** Member access emails are sent automatically after successful payments. Without SMTP configuration, members won't receive their access links.

### Other Configuration
- `JWT_SECRET` - Secret key for JWT token signing (use a strong random string)
- `BACKEND_BASE_URL` - Base URL for your backend API
- `FRONTEND_URL` - Base URL for your frontend application

## Using Docker Compose

Docker Compose will automatically read the `.env` file if it's in the same directory as `docker-compose.dev.yml`.

If you prefer, you can also set environment variables directly in your shell:

```bash
export STRIPE_SECRET_KEY=your_key_here
export TELEGRAM_BOT_TOKEN=your_token_here
# ... etc
```

## Development vs Production

- **Development:** Use `.env` file (gitignored)
- **Production:** Use your deployment platform's environment variable configuration (e.g., Docker secrets, Kubernetes secrets, etc.)

## Security Notes

- ⚠️ **Never commit `.env` to Git**
- ⚠️ **Never share `.env` files publicly**
- ⚠️ **Rotate secrets regularly**
- ⚠️ **Use different secrets for development and production**

