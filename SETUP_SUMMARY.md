# Earniqa Setup Summary

## Quick Start Guide

This document provides a high-level overview of the complete Earniqa setup process.

---

## For Creators

📖 **See [CREATOR_GUIDE.md](./CREATOR_GUIDE.md) for detailed step-by-step instructions**

### Essential Steps:

1. ✅ Sign up and log in
2. ✅ Connect Stripe account
3. ✅ Create membership plans
4. ✅ Add Telegram channels
5. ✅ **Add @earniqa_access_bot as administrator to Telegram channels**
6. ✅ Test the complete flow

---

## For Developers/System Administrators

### Required Services

1. **API Gateway** - Handles HTTP requests
2. **Access Worker** - Processes payments, grants access, sends emails
3. **Telegram Bot** - Handles bot commands
4. **MySQL** - Database
5. **NATS** - Message queue

### Required Environment Variables

#### API Gateway
- `TELEGRAM_BOT_TOKEN` - Bot token for Telegram operations
- `STRIPE_SECRET_KEY` - Stripe API key
- `STRIPE_WEBHOOK_SECRET` - Stripe webhook secret
- `STRIPE_CONNECT_CLIENT_ID` - Stripe Connect client ID
- `STRIPE_CONNECT_REDIRECT` - Stripe Connect redirect URL

#### Access Worker
- `TELEGRAM_BOT_TOKEN` - Bot token
- `TELEGRAM_BOT_USERNAME` - Bot username (`earniqa_access_bot`) ⚠️ **REQUIRED**
- `TELEGRAM_CHAT_ID` - Optional, for notifications

#### Telegram Bot Service
- `TELEGRAM_BOT_TOKEN` - Bot token (must match access-worker)
- `BACKEND_BASE_URL` - API Gateway URL

### Bot Configuration

**Bot Username:** `@earniqa_access_bot`  
**Bot Token:** `8162921390:AAEugXcf3DKtTGbs_QDLu4KVh_kKNy4Alvs`

**Important:** Make sure `TELEGRAM_BOT_USERNAME=earniqa_access_bot` is set in the access-worker environment.

---

## Complete Purchase Flow

1. **Creator Setup**
   - Connect Stripe
   - Create plans
   - Add channels
   - Add bot as admin

2. **Member Purchase**
   - Creator creates checkout session
   - Member completes payment
   - Webhook triggers access-worker
   - Access granted, token generated
   - Email sent with Telegram bot link

3. **Member Access**
   - Member clicks Telegram link
   - Bot consumes token
   - Bot creates invite links
   - Member joins channels

---

## Verification Tools

### Automated Scripts

1. **Verify Bot Admin Status:**
   ```bash
   /tmp/verify_telegram_bot_admin.sh
   ```
   Checks all channels in database and verifies bot admin status.

2. **Quick Setup Verification:**
   ```bash
   /tmp/quick_bot_setup.sh
   ```
   Interactive script to verify bot setup for a specific channel.

### Manual Verification

1. **Check Bot Token:**
   ```bash
   curl "https://api.telegram.org/bot8162921390:AAEugXcf3DKtTGbs_QDLu4KVh_kKNy4Alvs/getMe"
   ```

2. **Check Bot Admin Status:**
   ```bash
   curl "https://api.telegram.org/bot8162921390:AAEugXcf3DKtTGbs_QDLu4KVh_kKNy4Alvs/getChatAdministrators?chat_id=-1003390965999"
   ```

---

## Key Files

- `CREATOR_GUIDE.md` - Complete creator documentation
- `SETUP_SUMMARY.md` - This file (quick reference)
- `/tmp/MEMBER_PURCHASE_FLOW.md` - Detailed technical flow
- `/tmp/verify_telegram_bot_admin.sh` - Verification script
- `/tmp/quick_bot_setup.sh` - Quick setup script

---

## Troubleshooting Quick Reference

| Issue | Solution |
|-------|----------|
| Bot cannot access channel | Add bot as administrator with "Invite users" permission |
| Members not receiving email | Check `TELEGRAM_BOT_USERNAME` env var, check email service |
| Payment not processing | Check access-worker logs, verify webhook configuration |
| Bot commands not working | Verify bot service is running, check backend URL |

---

## Next Steps

1. Review `CREATOR_GUIDE.md` for detailed instructions
2. Set up your creator account
3. Add bot to your Telegram channels
4. Test the complete flow
5. Share checkout links with members

---

**Last Updated:** 2026-01-03

