# Access Token Expiration & Pending Token Lookup

## Current Implementation

### Token Expiration
- **Expires after 24 hours** from creation
- **Time-based expiration** (not usage-based)
- Token becomes invalid after 24 hours even if never used
- Code: `expiresAt := time.Now().UTC().Add(24 * time.Hour)`

### Token Validation
Tokens are valid when:
- `used_at IS NULL` (not already used)
- `expires_at IS NULL OR expires_at > now` (not expired)

### Pending Token Lookup
The bot supports auto-lookup of pending tokens:

**When Token is in URL** (email link):
- `https://t.me/bot?start=TOKEN`
- Token is provided directly → Works immediately
- Pending lookup NOT needed

**When No Token Provided** (`/start` command):
- Bot tries to find pending tokens by Telegram user ID
- Requires: Telegram user ID already linked to buyer record
- Useful for: Users who lost email link but already linked account once
- Limitation: Won't work on FIRST payment (user ID not linked yet)

## Questions Answered

### Q1: Is pending token fetching required?
**Answer:** No, it's optional but useful.
- **Email link flow:** Not required (token in URL)
- **Manual `/start` flow:** Required if user doesn't have token
- **First-time users:** Won't work (no linked Telegram user ID yet)
- **Returning users:** Works (Telegram user ID already linked)

### Q2: Is link valid until user joins?
**Answer:** No, token expires after 24 hours regardless of usage.
- Token expires **24 hours after creation**
- Not based on whether user joined or not
- Expiration is time-based, not usage-based

## Recommendations

### Option 1: Keep Current Behavior (24-hour expiration)
**Pros:**
- Security: Forces timely action
- Prevents link sharing after long periods
- Standard practice for access tokens

**Cons:**
- Users may miss 24-hour window
- Requires new token generation if expired

### Option 2: Extend Expiration Time
Change to 7 days or 30 days:
```go
expiresAt := time.Now().UTC().Add(7 * 24 * time.Hour) // 7 days
```

### Option 3: Usage-Based Expiration
Keep token valid until used (remove time-based expiration):
```go
expiresAt := nil // No expiration, valid until used
```

**Note:** Option 3 requires updating validation logic to only check `used_at`.

### Option 4: Long Expiration Until Used
Combine both: Long expiration (e.g., 30 days) but also check if used:
- Valid if: `(used_at IS NULL) AND (expires_at IS NULL OR expires_at > now)`
- Current implementation already does this!

## Current Flow Summary

1. **Payment Success** → Token created (expires in 24h)
2. **Email Sent** → Contains link with token
3. **User Clicks Link** → Opens bot with token
4. **Bot Validates** → Checks token is valid and not expired
5. **Bot Grants Access** → Adds user to channels
6. **Token Marked Used** → `used_at` set to current time
7. **Future Requests** → Token rejected (already used)

If user doesn't click link within 24 hours:
- Token expires (even if never used)
- User needs new token (contact support or re-pay)

