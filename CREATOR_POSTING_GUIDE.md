# Creator Posting Guide: Send Messages to VIP Channels

This guide explains how creators can send posts (text, images, links, or combinations) to their VIP Telegram channels via the Earniqa dashboard.

---

## Overview

The Earniqa platform allows creators to post content directly to their VIP Telegram channels from the dashboard. You can post:
- **Text messages**
- **Images** (via URLs)
- **Links**
- **Combinations** of all three

---

## API Endpoint

**Endpoint:** `POST /v1/integrations/channels/post`  
**Authentication:** Required (Creator JWT token)

---

## Request Format

### Basic Request Structure

```json
{
  "message": "Your message text here",
  "image_urls": ["https://example.com/image1.jpg", "https://example.com/image2.jpg"],
  "channel_ids": [1, 2],
  "scheduled_at": "2026-01-15T10:00:00Z"
}
```

### Request Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `message` | string | **Yes** (if no images) | The text message to post |
| `image_urls` | array of strings | No | URLs of images to post |
| `channel_ids` | array of numbers | No | Specific channel IDs to post to. If omitted, posts to all channels |
| `scheduled_at` | ISO 8601 datetime | No | Schedule post for future. If omitted, posts immediately |

### Notes:
- Either `message` OR `image_urls` (or both) must be provided
- If `channel_ids` is empty or omitted, the post goes to **all** your channels
- If `scheduled_at` is provided, the post is scheduled instead of posting immediately

---

## Examples

### Example 1: Text Message Only

```bash
POST /v1/integrations/channels/post
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "message": "🎉 Welcome to our VIP channel! Exclusive content coming soon..."
}
```

**cURL:**
```bash
curl -X POST "http://localhost:8080/v1/integrations/channels/post" \
  -H "Authorization: Bearer your_jwt_token" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "🎉 Welcome to our VIP channel! Exclusive content coming soon..."
  }'
```

---

### Example 2: Message with Images

```bash
POST /v1/integrations/channels/post
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "message": "Check out our latest design!",
  "image_urls": [
    "https://example.com/design1.jpg",
    "https://example.com/design2.jpg"
  ]
}
```

**cURL:**
```bash
curl -X POST "http://localhost:8080/v1/integrations/channels/post" \
  -H "Authorization: Bearer your_jwt_token" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Check out our latest design!",
    "image_urls": [
      "https://example.com/design1.jpg",
      "https://example.com/design2.jpg"
    ]
  }'
```

---

### Example 3: Message with Link

```bash
POST /v1/integrations/channels/post
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "message": "Read the full article here: https://example.com/article"
}
```

**Note:** Links can be included in the message text. Telegram will automatically parse and display them as clickable links.

---

### Example 4: Images Only (No Text)

```bash
POST /v1/integrations/channels/post
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "image_urls": [
    "https://example.com/image.jpg"
  ]
}
```

---

### Example 5: Post to Specific Channels

```bash
POST /v1/integrations/channels/post
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "message": "VIP members only announcement!",
  "channel_ids": [1, 3]
}
```

This posts only to channels with IDs 1 and 3, not all channels.

---

### Example 6: Schedule a Post

```bash
POST /v1/integrations/channels/post
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "message": "This post will be sent tomorrow at 10 AM",
  "scheduled_at": "2026-01-15T10:00:00Z"
}
```

**Note:** When `scheduled_at` is provided, the post is saved as a scheduled post instead of being sent immediately.

---

## Response Format

### Immediate Post Response

```json
{
  "success_count": 2,
  "failed_count": 0,
  "results": [
    {
      "channel_id": 1,
      "channel_kind": "telegram",
      "channel_ref": "-1001234567890",
      "success": true
    },
    {
      "channel_id": 2,
      "channel_kind": "telegram",
      "channel_ref": "-1009876543210",
      "success": true
    }
  ]
}
```

### Scheduled Post Response

When `scheduled_at` is provided, the response is different:

```json
{
  "scheduled_post": {
    "id": 123,
    "creator_id": "creator-1",
    "message": "Scheduled post message",
    "image_urls": [],
    "channel_ids": [1],
    "scheduled_at": "2026-01-15T10:00:00Z",
    "status": "pending",
    "created_at": "2026-01-14T12:00:00Z"
  }
}
```

---

## Getting Channel IDs

To get your channel IDs for posting to specific channels:

```bash
GET /v1/integrations/channels
Authorization: Bearer <your_token>
```

**Response:**
```json
{
  "items": [
    {
      "id": 1,
      "creator_id": "creator-1",
      "kind": "telegram",
      "ref": "-1001234567890",
      "created_at": "2026-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "creator_id": "creator-1",
      "kind": "telegram",
      "ref": "-1009876543210",
      "created_at": "2026-01-01T00:00:00Z"
    }
  ]
}
```

Use the `id` field in the `channel_ids` array.

---

## Image URLs Requirements

- Images must be accessible via HTTP/HTTPS
- URLs must point to actual image files (JPG, PNG, GIF, etc.)
- Images should be publicly accessible (no authentication required)
- Recommended: Use a CDN or image hosting service

### Supported Image Formats

Telegram supports:
- JPEG/JPG
- PNG
- GIF
- WebP

### Image Size Limits

- Maximum file size: 10 MB per image
- Recommended: Keep images under 5 MB for faster delivery

---

## Using the Dashboard (Frontend)

If the dashboard UI is available:

1. **Navigate to Integrations** page
2. **Select "Post to Channels"** or similar option
3. **Fill in the form:**
   - Enter your message text
   - Add image URLs (optional)
   - Select channels (optional - leave empty for all)
   - Set schedule time (optional - leave empty for immediate)
4. **Click "Post"** or "Schedule"

---

## Error Responses

### No Channels Configured

```json
{
  "error": "no_channels",
  "message": "No channels configured. Please add channels first."
}
```

**Solution:** Add channels via `POST /v1/integrations/channels`

### Invalid Request

```json
{
  "error": "message_or_images_required",
  "details": "..."
}
```

**Solution:** Provide either `message` or `image_urls` (or both)

### Channel Not Found

If a channel ID in `channel_ids` doesn't exist, it will be skipped (not cause an error).

---

## Best Practices

1. **Image Hosting**: Use reliable image hosting services (Cloudinary, AWS S3, etc.)
2. **URLs**: Always use HTTPS URLs for images
3. **Message Length**: Keep messages concise (Telegram has a 4096 character limit per message)
4. **Multiple Images**: Telegram sends images one at a time, so limit to 3-5 images per post
5. **Testing**: Test with one channel first before posting to all channels
6. **Scheduling**: Use scheduled posts for consistent content delivery

---

## Scheduled Posts

Scheduled posts are saved in the database and processed by a background worker.

### View Scheduled Posts

```bash
GET /v1/integrations/scheduled-posts
Authorization: Bearer <your_token>
```

### Update Scheduled Post

```bash
PUT /v1/integrations/scheduled-posts/:id
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "message": "Updated message",
  "scheduled_at": "2026-01-16T10:00:00Z"
}
```

### Delete Scheduled Post

```bash
DELETE /v1/integrations/scheduled-posts/:id
Authorization: Bearer <your_token>
```

---

## Complete Example Workflow

### Step 1: List Your Channels

```bash
curl -X GET "http://localhost:8080/v1/integrations/channels" \
  -H "Authorization: Bearer your_token"
```

### Step 2: Post a Message

```bash
curl -X POST "http://localhost:8080/v1/integrations/channels/post" \
  -H "Authorization: Bearer your_token" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "🎉 New VIP content is available! Check it out: https://example.com/vip-content",
    "image_urls": [
      "https://example.com/thumbnail.jpg"
    ],
    "channel_ids": [1]
  }'
```

### Step 3: Check Response

```json
{
  "success_count": 1,
  "failed_count": 0,
  "results": [
    {
      "channel_id": 1,
      "channel_kind": "telegram",
      "channel_ref": "-1001234567890",
      "success": true
    }
  ]
}
```

---

## Troubleshooting

### Post Not Appearing in Channel

1. **Check bot permissions**: Ensure the bot has permission to post messages
2. **Verify channel ID**: Check that the channel ID is correct
3. **Check response**: Look for errors in the API response
4. **Image URLs**: Verify image URLs are accessible
5. **Bot status**: Ensure the bot is still an administrator

### Images Not Showing

1. **URL accessibility**: Test the image URL in a browser
2. **HTTPS**: Use HTTPS URLs (required by Telegram)
3. **File format**: Ensure the file is a supported image format
4. **File size**: Check that the image is under 10 MB

### Scheduled Post Not Sending

1. **Check scheduled posts list**: Verify the post exists
2. **Status**: Check if status is "pending" or "processing"
3. **Worker service**: Ensure the scheduled post worker is running
4. **Time zone**: Verify the scheduled time is in UTC

---

## Quick Reference

**Post Immediately:**
```json
{
  "message": "Your message",
  "image_urls": ["https://example.com/image.jpg"]
}
```

**Post to Specific Channels:**
```json
{
  "message": "Your message",
  "channel_ids": [1, 2]
}
```

**Schedule Post:**
```json
{
  "message": "Your message",
  "scheduled_at": "2026-01-15T10:00:00Z"
}
```

---

**Last Updated:** 2026-01-03

