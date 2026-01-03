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

### Telegram Configuration
- `TELEGRAM_BOT_TOKEN` - Your Telegram bot token from @BotFather

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

