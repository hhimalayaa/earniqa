# Testing Member Subscription Flow

Complete guide to test how a member subscribes to a creator's membership plan and gets access to channels.

## Prerequisites Checklist

Before testing, ensure:

- [ ] Creator account exists and can log in
- [ ] Creator has connected Stripe (via Dashboard → Integrations)
- [ ] Creator has created at least one membership plan (via Dashboard → Membership Plans)
- [ ] Creator has added a Telegram channel (via Dashboard → Integrations)
- [ ] Telegram bot is admin in the channel with "Invite users via link" permission
- [ ] All workers are running:
  ```bash
  docker-compose -f docker-compose.dev.yml ps
  ```
  Should show: `access-worker`, `notification-worker`, `telegram-bot` as "Up"

## Quick Test (Using Script)

Run the interactive test script:

```bash
/tmp/test_member_subscription.sh
```

The script will guide you through:
1. Creator login
2. Checking/creating membership plans
3. Verifying Stripe connection
4. Creating checkout session
5. Instructions for completing payment

## Manual Testing Steps

### Step 1: Creator Login

```bash
curl -X POST http://localhost:8080/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "creator@example.com",
    "password": "password123"
  }'
```

Save the `token` and `creator_id` from the response.

### Step 2: Verify/Create Membership Plan

**Check existing plans:**
```bash
curl -X GET http://localhost:8080/v1/membership/plans \
  -H "Authorization: Bearer <creator_token>"
```

**If no plans exist, create one:**
```bash
curl -X POST http://localhost:8080/v1/membership/plans \
  -H "Authorization: Bearer <creator_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "VIP Monthly",
    "interval": "month",
    "price_id": "price_xxxxx"  # Get from Stripe Dashboard → Products
  }'
```

Save the `plan_id` from response.

### Step 3: Verify Stripe Connection

```bash
curl -X GET http://localhost:8080/v1/integrations/payment-sources \
  -H "Authorization: Bearer <creator_token>"
```

Should show Stripe with `status: "active"`.

### Step 4: Create Checkout Session

```bash
curl -X POST http://localhost:8080/v1/members/checkout \
  -H "Authorization: Bearer <creator_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "plan_id": 1,
    "success_url": "http://localhost:5173/success",
    "cancel_url": "http://localhost:5173/cancel"
  }'
```

Response contains `checkout_url` - open this in a browser.

### Step 5: Complete Payment

1. **Open checkout URL** in browser (from Step 4)
2. **Enter test card details:**
   - Card: `4242 4242 4242 4242`
   - Expiry: Any future date (e.g., `12/25`)
   - CVC: Any 3 digits (e.g., `123`)
   - Email: Member's email (e.g., `member@example.com`) - **Important!** This email will receive the access link
3. **Click "Subscribe"** or "Pay"
4. **Wait for redirect** to success URL

### Step 6: Monitor Payment Processing

**Watch access-worker logs:**
```bash
docker-compose -f docker-compose.dev.yml logs -f access-worker
```

You should see:
```
[access-worker] PaymentSucceeded received creator=... type=...
stored payment X for creator ...
granted telegram access to member@example.com for creator ...
```

**Watch backend logs for webhook:**
```bash
docker-compose -f docker-compose.dev.yml logs -f backend | grep webhook
```

Should see webhook received and processed.

### Step 7: Verify Database Records

**Check buyer record:**
```bash
docker-compose -f docker-compose.dev.yml exec db mysql -uearniqa -pearniqa earniqa \
  -e "SELECT * FROM buyers WHERE creator_id='<creator_id>';"
```

**Check payment record:**
```bash
docker-compose -f docker-compose.dev.yml exec db mysql -uearniqa -pearniqa earniqa \
  -e "SELECT * FROM payments WHERE creator_id='<creator_id>' ORDER BY created_at DESC LIMIT 1;"
```

**Check access token:**
```bash
docker-compose -f docker-compose.dev.yml exec db mysql -uearniqa -pearniqa earniqa \
  -e "SELECT token, buyer_id, expires_at FROM access_tokens ORDER BY created_at DESC LIMIT 1;"
```

### Step 8: Check Member Email

The member should receive an email with:
- Subject: "Welcome to [Creator Name] VIP - Your Access Links"
- Telegram bot link: `https://t.me/earniqa_access_bot?start=<token>`
- Access token for joining channels

**Note:** Email sending requires SMTP configuration. If emails aren't being sent, check:
- `notification-worker` logs
- SMTP environment variables in `.env`

### Step 9: Member Joins Telegram Channel

**Option A: Click email link (Recommended)**
1. Member clicks the Telegram link from email
2. Telegram opens with bot
3. Bot automatically processes `/start <token>`
4. Bot sends channel invite links
5. Member clicks links to join channels

**Option B: Manual bot command**
1. Member opens Telegram and searches for `@earniqa_access_bot`
2. Member starts conversation
3. Member sends: `/start <token_from_email>`
4. Bot responds with invite links
5. Member clicks links to join channels

### Step 10: Test Bot Commands

After joining, member can use:

**Check status:**
```
/status
```

**List all subscriptions:**
```
/mysubs
```

**Get help:**
```
/help
```

## Verification Checklist

After completing the test, verify:

- [ ] Payment completed successfully on Stripe
- [ ] Webhook received by backend (check logs)
- [ ] Payment record created in database
- [ ] Buyer record created with member email
- [ ] MemberSubscription record created
- [ ] AccessToken generated (24-hour validity)
- [ ] Access grants created for all channels
- [ ] Email sent to member (if SMTP configured)
- [ ] Telegram bot link works
- [ ] Bot can create invite links
- [ ] Member can join Telegram channel via invite link
- [ ] Bot commands work (`/status`, `/mysubs`)

## Troubleshooting

### Payment Completed but Nothing Happened

**Check:**
1. Access worker is running:
   ```bash
   docker-compose -f docker-compose.dev.yml ps access-worker
   ```
2. Access worker logs for errors:
   ```bash
   docker-compose -f docker-compose.dev.yml logs access-worker
   ```
3. Webhook was received:
   ```bash
   docker-compose -f docker-compose.dev.yml logs backend | grep webhook
   ```
4. NATS is running:
   ```bash
   docker-compose -f docker-compose.dev.yml ps nats
   ```

### No Email Received

**Check:**
1. Notification worker is running
2. SMTP configuration in `.env`:
   - `SMTP_HOST`
   - `SMTP_PORT`
   - `SMTP_USER`
   - `SMTP_PASS`
   - `EMAIL_FROM_ADDR`
   - `EMAIL_FROM_NAME`
3. Notification worker logs:
   ```bash
   docker-compose -f docker-compose.dev.yml logs notification-worker
   ```
4. Check spam folder

### Telegram Bot Link Not Working

**Check:**
1. Token hasn't expired (24-hour limit)
2. Token was used (one-time use per token)
3. Telegram bot service is running:
   ```bash
   docker-compose -f docker-compose.dev.yml ps telegram-bot
   ```
4. `TELEGRAM_BOT_TOKEN` environment variable is set
5. Bot can access backend API (check `BACKEND_BASE_URL`)

### Cannot Join Channel

**Check:**
1. Bot is administrator in Telegram channel
2. Bot has "Invite users via link" permission
3. Channel ID is correct in database
4. Invite link is still valid (they expire after some time)
5. Telegram bot logs for errors:
   ```bash
   docker-compose -f docker-compose.dev.yml logs telegram-bot
   ```

## Testing Different Scenarios

### Test 1: Free Plan Limit
If creator is on Free plan, test that 20 payments/month limit is enforced:
- Make 20 payments
- 21st payment should fail with "payment_limit_reached"

### Test 2: Multiple Channels
- Creator adds multiple Telegram channels
- Member subscribes
- Member should receive invite links for all channels

### Test 3: Subscription Renewal
- Wait for subscription period to end
- Stripe automatically charges member
- Access should remain active

### Test 4: Subscription Cancellation
- Member sends `/cancel` to bot
- Subscription should be marked for cancellation
- Access continues until period end

## Next Steps

After successful testing:
1. Document any issues found
2. Test with real Stripe account (not test mode)
3. Test with multiple creators and members
4. Test error scenarios (payment failures, expired tokens, etc.)

