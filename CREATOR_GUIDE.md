# Creator Guide: Setting Up Earniqa with Telegram Bot

This guide will help you set up your Earniqa account, connect payment methods, create membership plans, and integrate Telegram channels with the Earniqa bot.

---

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Connect Stripe Account](#connect-stripe-account)
3. [Create Membership Plans](#create-membership-plans)
4. [Add Telegram Channel](#add-telegram-channel)
5. [Add Bot to Telegram Channel](#add-bot-to-telegram-channel)
6. [Test Your Setup](#test-your-setup)
7. [Share Checkout Links with Members](#share-checkout-links-with-members)

---

## Initial Setup

### 1. Sign Up and Log In

1. **Sign up** as a creator:
   ```bash
   POST /v1/auth/signup
   {
     "email": "your-email@example.com",
     "password": "your-secure-password"
   }
   ```

2. **Log in** to get your authentication token:
   ```bash
   POST /v1/auth/login
   {
     "email": "your-email@example.com",
     "password": "your-secure-password"
   }
   ```
   
   **Response:**
   ```json
   {
     "token": "your-jwt-token-here",
     "creator_id": "creator-xxx"
   }
   ```

3. **Save your token** - You'll need it for all authenticated API calls:
   ```
   Authorization: Bearer your-jwt-token-here
   ```

---

## Connect Stripe Account

To accept payments from members, you need to connect your Stripe account.

### Steps:

1. **Initiate Stripe Connect**:
   ```bash
   POST /v1/integrations/connect/stripe/start
   Authorization: Bearer your-token
   ```

2. **You'll be redirected to Stripe** - Log in and authorize the connection

3. **After authorization**, you'll be redirected back to your dashboard

4. **Verify connection status**:
   ```bash
   GET /v1/integrations/payment-sources
   Authorization: Bearer your-token
   ```

   Look for a payment source with `"provider": "stripe"` and `"status": "connected"`

---

## Create Membership Plans

Create subscription plans that members can purchase.

### Create a Plan:

```bash
POST /v1/membership/plans
Authorization: Bearer your-token
Content-Type: application/json

{
  "name": "VIP Access",
  "description": "Full access to all VIP content",
  "price_minor": 999,           # $9.99 (in cents)
  "price_id": "price_xxxxx",    # Stripe Price ID
  "interval": "month",          # or "year"
  "currency": "usd"
}
```

**Important:**
- You need to create the Stripe Price first in your Stripe Dashboard
- Get the Price ID (starts with `price_`) and use it in the plan
- `price_minor` is the amount in cents (999 = $9.99)

### List Your Plans:

```bash
GET /v1/membership/plans
Authorization: Bearer your-token
```

---

## Add Telegram Channel

Add your Telegram channel/group to Earniqa so members can be granted access.

### Steps:

1. **Get your Telegram Channel ID**:
   - Add `@userinfobot` to your channel
   - Send any message
   - The bot will reply with your channel ID (it's a negative number like `-1001234567890`)
   - **Note:** Make sure to note this ID - you'll need it

2. **Add the channel to Earniqa**:
   ```bash
   POST /v1/integrations/channels
   Authorization: Bearer your-token
   Content-Type: application/json

   {
     "kind": "telegram",
     "ref": "-1001234567890"    # Your channel ID from step 1
   }
   ```

3. **Verify the channel was added**:
   ```bash
   GET /v1/integrations/channels
   Authorization: Bearer your-token
   ```

---

## Add Bot to Telegram Channel

**⚠️ IMPORTANT:** Before members can join your channel, you **must** add the Earniqa bot as an administrator.

### Step-by-Step Instructions:

#### 1. Find the Earniqa Bot

The bot username is: **@earniqa_access_bot**

#### 2. Add Bot to Your Channel

1. **Open your Telegram channel/group** (the one you added in the previous step)

2. **Go to Channel Settings**:
   - Tap on the channel name at the top
   - Tap "Administrators" (or "Manage Group" → "Administrators" for groups)

3. **Add Administrator**:
   - Tap "Add Administrator" or the "+" button
   - Search for `earniqa_access_bot` (or `@earniqa_access_bot`)
   - Select the bot from the results

4. **Set Permissions**:
   - **Required permissions:**
     - ✅ **Invite users via link** (CRITICAL - must be enabled)
     - ✅ **Manage chat** (recommended)
   - **Optional but recommended:**
     - ✅ Change info
     - ✅ Pin messages
     - ✅ Restrict members
   
   - **You can disable:**
     - ❌ Delete messages (optional)
     - ❌ Post messages (not needed)

5. **Save** the administrator settings

#### 3. Verify Bot is Added Correctly

You can verify the bot is an admin using this command (replace with your channel ID):

```bash
curl "https://api.telegram.org/bot<BOT_TOKEN>/getChatAdministrators?chat_id=<YOUR_CHANNEL_ID>"
```

Look for `"username": "earniqa_access_bot"` in the administrators list.

---

## Test Your Setup

Before sharing with members, test your setup:

### 1. Create a Test Checkout Session

```bash
POST /v1/members/checkout
Authorization: Bearer your-token
Content-Type: application/json

{
  "plan_id": 1,                                    # Your plan ID
  "success_url": "https://yoursite.com/success",
  "cancel_url": "https://yoursite.com/cancel"
}
```

**Response:**
```json
{
  "checkout_url": "https://checkout.stripe.com/pay/cs_...",
  "session_id": "cs_..."
}
```

### 2. Complete a Test Payment

- Open the `checkout_url` in a browser
- Complete the payment (use Stripe test cards)
- You should be redirected to `success_url`

### 3. Check Email

- Check the email address used in the payment
- You should receive an email with:
  - Telegram bot link: `https://t.me/earniqa_access_bot?start=<token>`
  - Instructions

### 4. Test Telegram Bot

1. Click the Telegram link from the email (or open `@earniqa_access_bot`)
2. The bot should automatically send you invite links
3. Click the links to join your VIP channel
4. Verify you can access the channel

### 5. Test Bot Commands

- `/status` - Check your subscription status
- `/mysubs` - List all your subscriptions
- `/help` - See available commands

---

## Share Checkout Links with Members

### Option 1: Direct API Integration

If you have a website, integrate the checkout API:

```bash
POST /v1/members/checkout
Authorization: Bearer your-token

{
  "plan_id": 1,
  "success_url": "https://yoursite.com/success",
  "cancel_url": "https://yoursite.com/cancel"
}
```

Redirect members to the returned `checkout_url`.

### Option 2: Generate Checkout Links Manually

1. Create a checkout session via API
2. Share the `checkout_url` with members
3. Members complete payment
4. They receive email with Telegram bot link
5. They click link and join your channel automatically

---

## Troubleshooting

### Bot Cannot Access Channel

**Problem:** Bot shows "chat not found" or "unauthorized"

**Solution:**
1. Verify the bot is added as an **Administrator** (not just a member)
2. Check that "Invite users via link" permission is enabled
3. Verify the channel ID is correct
4. Make sure you added `@earniqa_access_bot` (not a different bot)

### Members Not Receiving Email

**Problem:** Payment completed but no email received

**Solution:**
1. Check spam folder
2. Verify email service is configured correctly
3. Check access-worker logs for errors
4. Verify the email address used in payment matches the recipient

### Members Cannot Join Channel

**Problem:** Member clicks Telegram link but cannot join

**Solution:**
1. Verify bot is an admin in the channel
2. Check bot has "Invite users via link" permission
3. Verify the access token hasn't expired (24-hour limit)
4. Check bot logs for errors

### Payment Not Processing

**Problem:** Payment completed but access not granted

**Solution:**
1. Check Stripe webhook is configured correctly
2. Verify access-worker service is running
3. Check access-worker logs
4. Verify Stripe Connect account is active

---

## Quick Reference

### Essential Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/v1/auth/login` | POST | Log in as creator |
| `/v1/integrations/connect/stripe/start` | POST | Connect Stripe |
| `/v1/membership/plans` | POST | Create plan |
| `/v1/integrations/channels` | POST | Add Telegram channel |
| `/v1/members/checkout` | POST | Create checkout session |
| `/v1/members` | GET | List members |
| `/v1/members/:id` | GET | Get member details |

### Important IDs to Note

- **Creator ID**: Returned after login (e.g., `creator-1`)
- **Plan ID**: Returned when creating plan
- **Channel ID**: Telegram channel ID (negative number like `-1001234567890`)
- **Bot Username**: `@earniqa_access_bot`

### Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review service logs (access-worker, api-gateway, telegram-bot)
3. Verify all services are running
4. Check Stripe dashboard for payment status
5. Contact support with:
   - Creator ID
   - Plan ID
   - Channel ID
   - Error messages from logs

---

## Checklist

Use this checklist to ensure your setup is complete:

- [ ] Account created and logged in
- [ ] Stripe account connected and verified
- [ ] At least one membership plan created
- [ ] Telegram channel added to Earniqa
- [ ] Bot added as administrator to Telegram channel
- [ ] Bot has "Invite users via link" permission
- [ ] Test payment completed successfully
- [ ] Test email received with Telegram link
- [ ] Test Telegram bot link works
- [ ] Test member can join channel
- [ ] Bot commands tested (`/status`, `/mysubs`, etc.)

---

---

## Environment Configuration Note

**Important for System Administrators:**

The `access-worker` service requires the `TELEGRAM_BOT_USERNAME` environment variable to generate Telegram bot links in member access emails.

**Bot Username:** `earniqa_access_bot`

Make sure this is set in your deployment configuration:
```yaml
environment:
  - TELEGRAM_BOT_USERNAME=earniqa_access_bot
```

---

**Last Updated:** 2026-01-03

