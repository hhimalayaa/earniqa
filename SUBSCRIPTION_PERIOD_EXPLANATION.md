# Subscription Period/Billing Interval Explanation

## Issue
If a member purchases a 6-month membership, the system shows renewal after 1 month instead of 6 months.

## Root Cause
The subscription period is determined by **Stripe Price configuration**, not by the `membership_plans.interval` field in the database.

## How It Works

### 1. Stripe Subscription Intervals
Stripe subscriptions use the **Price object's billing interval**:
- Monthly: `interval: "month"`, `interval_count: 1`
- 6 Months: `interval: "month"`, `interval_count: 6`
- Yearly: `interval: "year"`, `interval_count: 1`

### 2. What We Store
- `membership_plans.interval`: Display field (e.g., "month", "6_months", "year")
- `membership_plans.price_id`: Stripe Price ID (this determines actual billing)

### 3. Webhook Processing
When Stripe sends webhook events:
- `current_period_end` comes from Stripe's subscription (correct based on Price interval)
- Our code uses this value directly (correct behavior)
- The `billing_period` metadata field is just for display/reference

## Solution

### For Creators
When creating a membership plan:
1. Create the Stripe Price with the correct interval:
   - 6-month plan → Price with `interval: "month"`, `interval_count: 6`
   - 1-year plan → Price with `interval: "year"`, `interval_count: 1`
2. Use the Stripe Price ID in the membership plan's `price_id` field

### Current Behavior
- If the Stripe Price is configured for monthly billing, subscriptions will renew monthly
- Even if `membership_plans.interval` says "6_months", the actual billing follows the Price interval
- The `current_period_end` from Stripe webhooks is always correct

## Verification

Check the Stripe Price configuration:
```bash
# In Stripe Dashboard or via API
stripe prices retrieve <price_id>
# Check: interval (month/year) and interval_count (1, 6, 12, etc.)
```

The `current_period_end` in `member_subscriptions` table reflects the actual subscription period from Stripe.

