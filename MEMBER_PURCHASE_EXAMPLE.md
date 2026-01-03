# Member Purchase Flow - Complete Example

This document provides a complete, step-by-step example of how a member purchases a creator's membership plan.

---

## Prerequisites

- Creator account is set up
- Stripe account is connected
- Membership plan exists
- Telegram channel is added
- Bot is added as administrator to Telegram channel

---

## Complete Flow Example

### Step 1: Creator Creates Checkout Session

**API Call:**
```bash
POST http://localhost:8080/v1/members/checkout
Authorization: Bearer <creator_jwt_token>
Content-Type: application/json

{
  "plan_id": 1,
  "success_url": "https://yoursite.com/success",
  "cancel_url": "https://yoursite.com/cancel"
}
```

**Example Request (using curl):**
```bash
curl -X POST "http://localhost:8080/v1/members/checkout" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "plan_id": 1,
    "success_url": "https://yoursite.com/success",
    "cancel_url": "https://yoursite.com/cancel"
  }'
```

**Response:**
```json
{
  "checkout_url": "https://checkout.stripe.com/pay/cs_test_a1b2c3d4e5f6...",
  "session_id": "cs_test_a1b2c3d4e5f6..."
}
```

---

### Step 2: Member Completes Payment

1. **Member opens the checkout URL** in their browser:
   ```
   https://checkout.stripe.com/pay/cs_test_a1b2c3d4e5f6...
   ```

2. **Member enters payment details:**
   - For testing, use Stripe test card: `4242 4242 4242 4242`
   - Expiry: Any future date (e.g., `12/25`)
   - CVC: Any 3 digits (e.g., `123`)
   - Email: Member's email address (e.g., `member@example.com`)

3. **Member clicks "Pay"** and completes the payment

4. **Stripe redirects** to `success_url` on success

---

### Step 3: System Processes Payment (Automatic)

**What happens automatically:**

1. **Stripe sends webhook** to your backend:
   ```
   POST /webhooks/stripe/:creatorId
   ```

2. **Webhook handler** processes the payment:
   - Validates the payment
   - Publishes `PaymentSucceeded` event to NATS

3. **Access Worker** receives the event and:
   - Creates/updates `Buyer` record with member's email
   - Creates `MemberSubscription` record
   - Creates `AccessGrant` records for all channels
   - Generates 24-hour `AccessToken`
   - Sends email to member with access links

---

### Step 4: Member Receives Email

**Email Contents:**
```
Subject: Welcome to [Creator Name] VIP - Your Access Links

Hi!

Your payment was successful! You now have VIP access to [Creator Name].

Here are your access links:

📱 TELEGRAM
Join here: https://t.me/earniqa_access_bot?start=access_token_abc123xyz
Click this link to join the Telegram VIP channel.

Important Notes:
- Telegram link expires in 24 hours. If you need a new link, contact support.
- Keep these links private and don't share them with others.
- If you have any issues, reply to this email.

Enjoy your VIP access!
– Earniqa
```

---

### Step 5: Member Joins Telegram Channel

#### Option A: Click Email Link (Automatic)

1. **Member clicks the Telegram link** from email:
   ```
   https://t.me/earniqa_access_bot?start=access_token_abc123xyz
   ```

2. **Telegram opens** with the bot and automatically sends `/start access_token_abc123xyz`

3. **Bot processes the command:**
   - Calls `/v1/access/telegram/consume-token` API
   - Validates and marks token as used
   - Gets channel IDs for the creator
   - Creates invite links for each channel

4. **Bot sends invite links:**
   ```
   Here is your VIP access link for channel:
   https://t.me/joinchat/ABC123xyz...
   
   All your VIP channel links have been sent. Tap each link to join.
   ```

5. **Member clicks invite links** to join VIP channels

#### Option B: Manual Bot Command

1. **Member opens Telegram** and searches for `@earniqa_access_bot`

2. **Member starts conversation** with the bot

3. **Member sends command:**
   ```
   /start access_token_abc123xyz
   ```
   (Token from the email)

4. **Bot responds** with invite links (same as Option A)

---

### Step 6: Member Uses Bot Commands

After joining, members can use various bot commands:

#### Check Status
```
/status
```
**Response:**
```
📊 Subscription Status

Creator: Creator Name
Status: Active
Renews at: 2026-02-03 12:00:00 UTC
```

#### List All Subscriptions
```
/mysubs
```
**Response:**
```
📋 Your Subscriptions

1. Creator Name
   Status: Active
   Renews: 2026-02-03 12:00:00 UTC

2. Another Creator
   Status: Active
   Renews: 2026-02-10 12:00:00 UTC

To cancel a subscription, use /cancel in that creator's channel, or send me a DM with /cancel.
```

#### Cancel Subscription
```
/cancel
```
**Note:** This command only works in private messages (DMs) for privacy.

**Response (if single subscription):**
```
✅ Subscription cancelled successfully!

Creator: Creator Name
You will lose access at the end of your current billing period.

A confirmation email has been sent to you.
```

**Response (if multiple subscriptions):**
```
You have multiple subscriptions. Which one would you like to cancel?

1. Creator Name (active)
2. Another Creator (active)

[Cancel Creator Name Button]
[Cancel Another Creator Button]
```

#### Get Help
```
/help
```
**Response:**
```
Earniqa Bot Commands:

/start <token> - Join VIP channels using your access token
/cancel - Cancel your subscription
/status - Check your subscription status
/mysubs - List all your subscriptions
/help - Show this help message

You can use all commands here in private messages.
```

---

## Complete Example: End-to-End Test

### Prerequisites Setup (One-time)

```bash
# 1. Creator Login
curl -X POST "http://localhost:8080/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"creator@example.com","password":"password123"}'

# Save the token from response

# 2. Create Membership Plan (if not exists)
curl -X POST "http://localhost:8080/v1/membership/plans" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "VIP Access",
    "price_minor": 999,
    "price_id": "price_1ABC123...",
    "interval": "month"
  }'

# 3. Add Telegram Channel
curl -X POST "http://localhost:8080/v1/integrations/channels" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "kind": "telegram",
    "ref": "-1001234567890"
  }'
```

### Member Purchase Flow

```bash
# 1. Create Checkout Session
curl -X POST "http://localhost:8080/v1/members/checkout" \
  -H "Authorization: Bearer <creator_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "plan_id": 1,
    "success_url": "https://yoursite.com/success",
    "cancel_url": "https://yoursite.com/cancel"
  }'

# Response contains checkout_url - open in browser

# 2. Complete payment on Stripe checkout page
# Use test card: 4242 4242 4242 4242
# Email: member@example.com

# 3. Check email for Telegram bot link

# 4. Click link or manually send to bot:
# /start <token_from_email>

# 5. Receive invite links and join channels

# 6. Test bot commands:
# /status
# /mysubs
# /help
```

---

## Testing Checklist

- [ ] Creator can create checkout session
- [ ] Checkout URL is accessible
- [ ] Payment can be completed with test card
- [ ] Webhook receives payment event
- [ ] Access worker processes payment
- [ ] Buyer record is created
- [ ] Access grants are created
- [ ] Access token is generated
- [ ] Email is sent to member
- [ ] Telegram bot link works
- [ ] Bot can create invite links
- [ ] Member can join channels
- [ ] Bot commands work correctly

---

## Troubleshooting

### Payment Completed but No Email

**Check:**
1. Access worker logs
2. Email service configuration
3. `TELEGRAM_BOT_USERNAME` environment variable
4. Member's email address in payment

### Bot Link Not Working

**Check:**
1. Token hasn't expired (24-hour limit)
2. Token was used (one-time use)
3. Bot service is running
4. Bot can access backend API

### Cannot Join Channel

**Check:**
1. Bot is administrator in channel
2. Bot has "Invite users via link" permission
3. Invite link is still valid
4. Channel ID is correct

---

**Last Updated:** 2026-01-03

