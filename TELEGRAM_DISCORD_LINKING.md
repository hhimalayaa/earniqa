# Telegram/Discord User ID Linking

## Overview
Telegram and Discord user IDs are linked to buyers when members use the bot commands after making a payment.

## Flow

### 1. Member Makes Payment
- Member subscribes to a creator's membership plan
- Payment is processed via Stripe
- Access token is created for the buyer
- Email is sent with access links

### 2. Member Links Account via Telegram Bot
- Member opens Telegram and finds the creator's bot
- Member sends `/start` command (token is optional - bot auto-finds it)
- Bot calls `/v1/access/telegram/consume-token` API endpoint
- API endpoint calls `buyerRepo.UpdateTelegramUserID()` to link Telegram user ID to buyer
- Buyer record is updated with `telegram_user_id`

### 3. Member Links Account via Discord Bot
- Similar flow, but via Discord bot
- Uses `/v1/access/discord/consume-token` endpoint
- Updates `discord_user_id` field on buyer record

## API Endpoints

### Telegram
- **Endpoint**: `POST /v1/access/telegram/consume-token`
- **Body**: 
  ```json
  {
    "token": "optional-token",
    "telegram_user_id": "123456789"
  }
  ```
- **Query Params**: `creator_id` (optional)
- **Handler**: `TelegramConsumeToken` in `backend/internal/domain/access/handlers.go`
- **Updates**: `buyers.telegram_user_id`

### Discord
- **Endpoint**: `POST /v1/access/discord/consume-token`
- **Similar structure to Telegram**

## Important Notes

1. **User IDs are NULL until linking**: Buyer records start with `telegram_user_id` and `discord_user_id` as NULL
2. **Linking happens after payment**: Members must first pay, then use the bot to link their account
3. **Auto-token lookup**: The Telegram bot can automatically find pending tokens by Telegram user ID (no token required in `/start` command)
4. **One-time linking**: Once linked, the user ID persists in the buyer record

## Database Schema

```sql
CREATE TABLE buyers (
  id BIGINT UNSIGNED PRIMARY KEY,
  creator_id VARCHAR(64),
  email VARCHAR(191),
  telegram_user_id BIGINT NULL,  -- Set when member uses /start in Telegram
  discord_user_id VARCHAR(191) NULL,  -- Set when member uses Discord bot
  ...
);
```

