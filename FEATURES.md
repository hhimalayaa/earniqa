# Earniqa - Complete Features Documentation

**Last Updated:** December 29, 2025

---

## Table of Contents

1. [Overview](#overview)
2. [Core Features](#core-features)
3. [Creator Features](#creator-features)
4. [Member Features](#member-features)
5. [Platform Features](#platform-features)
6. [Integration Features](#integration-features)
7. [Automation & Workers](#automation--workers)
8. [Security & Fraud Detection](#security--fraud-detection)
9. [Admin Features](#admin-features)
10. [Analytics & Reporting](#analytics--reporting)
11. [Communication Features](#communication-features)
12. [Technical Features](#technical-features)

---

## Overview

**Earniqa** is a comprehensive creator membership platform that enables creators to monetize their communities through paid memberships on platforms like Telegram, Discord, WhatsApp, and Slack. It handles payment processing, access management, and automated workflows while ensuring creators maintain full control over their funds.

### Core Philosophy

- **Creator-Owned Payments**: Payments go directly to creators' payment accounts (Stripe Connect, Razorpay, etc.) - Earniqa never holds funds
- **Provider-Agnostic**: Supports multiple payment providers and community platforms
- **Automated Access Management**: Automatic access granting/revoking based on payment status
- **Event-Driven Architecture**: Webhook-driven, reliable, and scalable

---

## Core Features

### 1. Creator Account Management

#### Signup & Authentication
- ✅ Creator signup with email/password
- ✅ Secure JWT-based authentication
- ✅ Creator login/logout
- ✅ Workspace creation and management
- ✅ Multi-creator support (multiple workspaces per user)

#### Creator Profile
- ✅ Profile management
- ✅ Workspace settings
- ✅ Creator status management (active, suspended)
- ✅ Email notification preferences

### 2. Subscription Plans (Earniqa Platform)

#### Platform Plans
Earniqa offers three platform subscription tiers:

- **Free Plan**
  - Basic features for getting started
  - Limited member transactions per month
  - Basic integrations

- **Prime Plan**
  - Advanced features for growing creators
  - Higher transaction limits
  - Priority support

- **Pro Plan**
  - Full feature set for professional creators
  - Unlimited transactions
  - Premium support and features

#### Plan Management
- ✅ List available Earniqa plans
- ✅ Check current plan
- ✅ Upgrade/downgrade plans
- ✅ Plan pricing by billing period (monthly/yearly)
- ✅ Subscription status tracking
- ✅ Usage limits enforcement
- ✅ Billing period tracking

### 3. Membership Plans (Creator-Defined)

#### Plan Creation
- ✅ Create custom membership plans
- ✅ Set pricing (integrated with Stripe prices)
- ✅ Define billing intervals (monthly, quarterly, yearly, custom)
- ✅ Multiple plans per creator
- ✅ Plan activation/deactivation

#### Plan Features
- ✅ Plan name and description
- ✅ Pricing tiers
- ✅ Billing cycle configuration
- ✅ Plan limits (based on creator's Earniqa plan)
- ✅ Stripe Price ID integration

### 4. Member Management

#### Member Records
- ✅ Buyer/member identity management
- ✅ Email-based member records
- ✅ Telegram User ID linking
- ✅ Discord User ID linking
- ✅ Phone number support
- ✅ Member import tracking (imported vs organic)
- ✅ Import source tracking

#### Member Subscriptions
- ✅ Active subscription tracking
- ✅ Subscription status (active, past_due, expired, canceled)
- ✅ Billing period tracking
- ✅ Grace period management
- ✅ Retry attempt tracking
- ✅ Subscription renewal management

#### Member Access
- ✅ Access grant management
- ✅ Multi-channel access support
- ✅ Access token generation
- ✅ Invitation link generation
- ✅ Access revocation on payment failure/refund

---

## Creator Features

### 1. Payment Integration

#### Payment Providers Supported
- ✅ **Stripe Connect** (Primary)
  - OAuth-based Connect onboarding
  - Direct payments to creator's Stripe account
  - Webhook integration
  - Checkout session creation
  
- ✅ **Razorpay** (Planned/In Development)
  - API key-based connection
  - Direct payments to creator's Razorpay account
  
- ✅ **Crypto Payments** (Planned/In Development)
  - Coinbase Commerce integration
  - Other crypto payment processors

#### Payment Source Management
- ✅ Connect payment providers
- ✅ List connected payment sources
- ✅ Disconnect payment sources
- ✅ Payment source status tracking
- ✅ Multiple payment providers per creator

#### Payment Processing
- ✅ Member checkout session creation
- ✅ Payment webhook handling
- ✅ Payment verification (signature validation)
- ✅ Event normalization (provider-agnostic)
- ✅ Idempotent payment processing

### 2. Channel Integrations

#### Supported Platforms
- ✅ **Telegram**
  - Private channel management
  - Bot-based access control
  - Member join detection
  - Auto-import existing members
  - Scheduled posts
  - Image posting support
  
- ✅ **Discord**
  - Server role management
  - Channel access control
  - Bot commands
  - Scheduled posts
  - Image posting support
  
- ✅ **WhatsApp** (Planned)
  - Group management
  - Access control
  
- ✅ **Slack** (Planned)
  - Workspace management
  - Channel access

#### Channel Management
- ✅ Add channels (Telegram, Discord, etc.)
- ✅ List connected channels
- ✅ Delete channels
- ✅ Channel status tracking
- ✅ Channel metadata (name, ID, type)

#### Channel Posting
- ✅ Immediate posts to channels
- ✅ Scheduled posts (date/time-based)
- ✅ Multi-channel posting (post to multiple channels at once)
- ✅ Image posting support
- ✅ Message formatting (HTML for Telegram, Markdown for Discord)
- ✅ Post status tracking (pending, processing, completed, failed)

### 3. Content Scheduling

#### Scheduled Posts
- ✅ Create scheduled posts
- ✅ Schedule posts to specific date/time
- ✅ Select target channels
- ✅ Message content with images
- ✅ Edit scheduled posts
- ✅ Delete scheduled posts
- ✅ View scheduled post history
- ✅ Post status tracking
- ✅ Automatic posting (background worker)

#### Post Features
- ✅ Text messages
- ✅ Image attachments (via URLs)
- ✅ Multi-image support
- ✅ HTML/Markdown formatting
- ✅ Channel-specific formatting

### 4. Member Checkout

#### Checkout Flow
- ✅ Generate checkout links for members
- ✅ Stripe Checkout Session creation (on creator's account)
- ✅ Payment directly to creator
- ✅ Success/cancel URL handling
- ✅ Member email capture
- ✅ Automatic access granting after payment

#### Checkout Features
- ✅ Multiple membership plans
- ✅ Plan selection
- ✅ Secure payment processing
- ✅ Payment confirmation
- ✅ Access token generation
- ✅ Welcome email with access links

### 5. Analytics Dashboard

#### Summary Analytics
- ✅ Active members count
- ✅ New members (30 days)
- ✅ Revenue (30 days)
- ✅ Currency tracking
- ✅ Quick stats overview

#### Revenue Analytics
- ✅ Revenue by period (7d, 30d, 90d, 1y)
- ✅ Revenue breakdown by day/week/month
- ✅ Transaction counts
- ✅ Growth percentage
- ✅ Revenue trends

#### Member Growth Analytics
- ✅ Member growth by period
- ✅ Daily new member tracking
- ✅ Total members over time
- ✅ Growth rate calculation

#### Data Export
- ✅ Export analytics data (CSV, JSON, XLSX)
- ✅ Date range filtering
- ✅ Custom export formats
- ✅ Scheduled exports (future)

### 6. Settings & Configuration

#### Creator Settings
- ✅ Workspace name
- ✅ Email preferences
- ✅ Notification settings
- ✅ Webhook URL configuration
- ✅ Profile customization

#### Integration Settings
- ✅ Payment provider configuration
- ✅ Channel connection settings
- ✅ Bot token management
- ✅ Webhook URL management

---

## Member Features

### 1. Membership Subscription

#### Checkout Experience
- ✅ Secure checkout page
- ✅ Multiple plan options
- ✅ Payment method selection
- ✅ Payment confirmation
- ✅ Automatic access activation

#### Subscription Management
- ✅ View active subscriptions (via Telegram bot)
- ✅ Subscription status checking
- ✅ Cancel subscription (via Telegram bot)
- ✅ Renewal reminders

### 2. Access Management

#### Access Tokens
- ✅ Automatic token generation
- ✅ Token-based access links
- ✅ Telegram bot deep links
- ✅ Token expiration (24 hours)
- ✅ Secure token validation

#### Channel Access
- ✅ Automatic channel joining
- ✅ Multi-channel access
- ✅ Access revocation on payment failure
- ✅ Access restoration on payment success

### 3. Telegram Bot Commands

#### Available Commands
- ✅ `/start` - Initialize bot and get access
- ✅ `/status` - Check subscription status
- ✅ `/mysubs` - List all active subscriptions
- ✅ `/cancel` - Cancel subscription
- ✅ `/link-account` - Link Telegram account to email

#### Bot Features
- ✅ Member join detection
- ✅ Automatic member import
- ✅ Status notifications
- ✅ Access link generation
- ✅ Subscription management

---

## Platform Features

### 1. Theme Management

#### Theme System
- ✅ Customizable platform themes
- ✅ Color scheme configuration
- ✅ Font customization
- ✅ Logo and favicon support
- ✅ Active theme selection
- ✅ Public theme API (for frontend)

#### Theme Features
- ✅ Multiple theme support
- ✅ Theme activation/deactivation
- ✅ Theme preview
- ✅ Admin theme management

### 2. Payment Provider Management

#### Provider Configuration
- ✅ Enable/disable payment providers globally
- ✅ Provider metadata (display name, description)
- ✅ Provider status tracking
- ✅ Provider-specific settings

#### Supported Providers
- ✅ Stripe
- ✅ Razorpay (planned)
- ✅ PayPal (planned)
- ✅ Crypto wallets (planned)

### 3. Webhook Management

#### Webhook Handling
- ✅ Stripe webhook verification
- ✅ Platform webhook endpoint
- ✅ Creator-specific webhook endpoints
- ✅ Webhook event normalization
- ✅ Webhook replay capability
- ✅ Webhook security (signature verification)

#### Event Types
- ✅ `payment.succeeded`
- ✅ `payment.failed`
- ✅ `payment.refunded`
- ✅ `payment.disputed`
- ✅ `subscription.expired`
- ✅ `subscription.renewed`

---

## Integration Features

### 1. Telegram Integration

#### Bot Features
- ✅ Member join detection
- ✅ Member status checking
- ✅ Subscription management commands
- ✅ Channel management
- ✅ Automatic access granting
- ✅ Member kicking on expiry
- ✅ Existing member detection
- ✅ Auto-import on interaction

#### Channel Management
- ✅ Add Telegram channels
- ✅ Verify channel ownership
- ✅ Member count tracking
- ✅ Channel metadata

### 2. Discord Integration

#### Bot Features
- ✅ Role assignment on payment
- ✅ Role removal on payment failure
- ✅ Server management
- ✅ Channel access control
- ✅ Scheduled posts

#### Channel Management
- ✅ Add Discord servers
- ✅ Channel ID management
- ✅ Server role configuration

### 3. Stripe Connect Integration

#### OAuth Flow
- ✅ Start Stripe Connect OAuth
- ✅ OAuth callback handling
- ✅ Access token storage
- ✅ Account ID linking
- ✅ Connection status tracking

#### Connect Features
- ✅ Direct payments to creator accounts
- ✅ Webhook forwarding to creators
- ✅ Account verification
- ✅ Dashboard linking

---

## Automation & Workers

### 1. Access Worker

#### Responsibilities
- ✅ Process payment success events
- ✅ Create/update buyer records
- ✅ Store payment records
- ✅ Grant access on payment success
- ✅ Revoke access on payment failure/refund
- ✅ Send welcome emails with access links
- ✅ Create access tokens
- ✅ Handle platform billing (creator → Earniqa)

#### Event Handlers
- ✅ `payment.succeeded` → Grant access
- ✅ `payment.failed` → Revoke access (legacy)
- ✅ `payment.refunded` → Revoke access
- ✅ `payment.disputed` → Revoke access

### 2. Dunning Worker

#### Responsibilities
- ✅ Handle subscription renewals
- ✅ Process payment failures
- ✅ Retry logic with exponential backoff
- ✅ Grace period management (48 hours default)
- ✅ Subscription expiry enforcement
- ✅ Automatic access revocation
- ✅ Auto-kick expired members from channels

#### Periodic Jobs
- ✅ **Member Grace Expiry** (every 5 minutes)
  - Check for expired grace periods
  - Revoke access
  - Kick members from channels
  - Mark subscriptions as expired
  
- ✅ **Dunning Retry** (every 1 hour)
  - Retry failed payments
  - Update retry attempts
  - Exponential backoff
  
- ✅ **Full Membership Expiry** (every 1 hour)
  - Check for expired memberships (beyond grace)
  - Revoke access
  - Kick members
  
- ✅ **Creator Subscription Expiry** (every 1 hour)
  - Check for expired creator subscriptions
  - Mark as canceled

#### Event Handlers
- ✅ `payment.failed` → Mark past_due, set grace period
- ✅ Grace expiry → Revoke access, kick members
- ✅ Membership expiry → Revoke access, kick members

### 3. Dispute Worker

#### Responsibilities
- ✅ Handle chargebacks and disputes
- ✅ Immediate access revocation
- ✅ Payment audit logging
- ✅ Evidence collection and storage
- ✅ Dispute notification

#### Event Handlers
- ✅ `payment.disputed` → Save evidence, revoke access
- ✅ `payment.refunded` → Save evidence, revoke access

#### Evidence Management
- ✅ Save payment events as evidence
- ✅ JSON evidence files
- ✅ Timestamped evidence
- ✅ Creator-specific evidence organization

### 4. Notification Worker

#### Responsibilities
- ✅ Send automated email notifications
- ✅ Process scheduled posts
- ✅ Payment success notifications
- ✅ Payment failure notifications
- ✅ Subscription expiry notifications
- ✅ Welcome emails
- ✅ Access granted notifications

#### Email Notifications
- ✅ **Member Notifications:**
  - Payment success
  - Payment failure
  - Subscription expired
  - Access granted (with links)
  - Refund notification
  
- ✅ **Creator Notifications:**
  - New member payment received
  - Payment dispute opened
  - Refund notification
  - Member subscription expired

#### Scheduled Posts Processor
- ✅ Check for pending scheduled posts (every 1 minute)
- ✅ Process due posts
- ✅ Post to Telegram/Discord channels
- ✅ Image posting support
- ✅ Multi-channel posting
- ✅ Post status tracking
- ✅ Error handling and retry

---

## Security & Fraud Detection

### 1. Fraud Detection

#### Fraud Checks
- ✅ Multiple rapid payments detection
- ✅ Unusually large amount detection
- ✅ Payment pattern analysis
- ✅ Confidence scoring
- ✅ Fraud flagging

#### Fraud Patterns
- ✅ Too many rapid payments (5+ in 5 minutes)
- ✅ Unusually large amounts (>$10,000)
- ✅ Suspicious payment patterns
- ✅ Anomaly detection

### 2. Security Features

#### Authentication & Authorization
- ✅ JWT-based authentication
- ✅ Role-based access control (Creator, Admin)
- ✅ Secure password hashing
- ✅ Token expiration
- ✅ Session management

#### Payment Security
- ✅ Webhook signature verification (Stripe)
- ✅ Idempotent payment processing
- ✅ Payment event replay protection
- ✅ Secure payment data handling
- ✅ PCI compliance (via Stripe)

#### Access Security
- ✅ Secure access token generation
- ✅ Token expiration (24 hours)
- ✅ Token validation
- ✅ Channel access verification

---

## Admin Features

### 1. Creator Management

#### Creator Administration
- ✅ List all creators
- ✅ View creator details
- ✅ Creator status management (active, suspended)
- ✅ Creator metrics viewing
- ✅ Creator subscription management

#### Creator Analytics
- ✅ Total creators
- ✅ Active creators
- ✅ Creator growth analytics
- ✅ Creator plan distribution

### 2. Payment Provider Management

#### Provider Administration
- ✅ List all payment providers
- ✅ Enable/disable providers globally
- ✅ Provider metadata management
- ✅ Provider status tracking
- ✅ Provider usage analytics

### 3. Theme Management (Admin)

#### Theme Administration
- ✅ Create themes
- ✅ Update themes
- ✅ Delete themes
- ✅ Activate themes
- ✅ List all themes
- ✅ Theme preview

### 4. Platform Analytics

#### Overview Analytics
- ✅ Total creators
- ✅ Active creators
- ✅ Total members
- ✅ Active members
- ✅ Total revenue
- ✅ Active subscriptions
- ✅ Payment provider usage

#### Growth Analytics
- ✅ Creator growth over time
- ✅ Member growth over time
- ✅ Revenue trends
- ✅ Subscription trends

---

## Analytics & Reporting

### 1. Creator Analytics

#### Revenue Analytics
- ✅ Revenue by period (7d, 30d, 90d, 1y)
- ✅ Daily/weekly/monthly breakdowns
- ✅ Revenue growth percentage
- ✅ Transaction counts
- ✅ Average transaction value

#### Member Analytics
- ✅ Active members count
- ✅ New members (last 30 days)
- ✅ Member growth rate
- ✅ Member retention
- ✅ Subscription status distribution

#### Export Capabilities
- ✅ CSV export
- ✅ JSON export
- ✅ XLSX export
- ✅ Date range filtering
- ✅ Custom export formats

### 2. Platform Analytics (Admin)

#### Platform Metrics
- ✅ Total creators
- ✅ Active creators
- ✅ Total members
- ✅ Active members
- ✅ Total revenue
- ✅ Payment provider usage
- ✅ Platform growth trends

---

## Communication Features

### 1. Email Notifications

#### Automated Emails
- ✅ **Member Emails:**
  - Welcome email with access links
  - Payment success notification
  - Payment failure notification
  - Subscription expiry notification
  - Refund notification
  - Access granted notification
  
- ✅ **Creator Emails:**
  - New member payment received
  - Payment dispute opened
  - Refund notification
  - Member subscription expired
  - Platform subscription updates

#### Email Features
- ✅ SMTP support (Mailpit, Gmail, SES, etc.)
- ✅ HTML email templates
- ✅ Personalized email content
- ✅ Multi-language support (future)

### 2. Telegram Bot Communication

#### Bot Commands
- ✅ `/start` - Initialize and get access
- ✅ `/status` - Check subscription status
- ✅ `/mysubs` - List active subscriptions
- ✅ `/cancel` - Cancel subscription
- ✅ `/link-account` - Link Telegram to email

#### Bot Features
- ✅ Interactive commands
- ✅ Status messages
- ✅ Error messages
- ✅ Help messages
- ✅ Deep link support

### 3. Channel Posting

#### Content Posting
- ✅ Text messages
- ✅ Image posts
- ✅ Multi-image posts
- ✅ HTML/Markdown formatting
- ✅ Multi-channel posting

---

## Technical Features

### 1. Architecture

#### Event-Driven Architecture
- ✅ NATS JetStream message queue
- ✅ Event normalization (provider-agnostic)
- ✅ Event replay capability
- ✅ Idempotent event processing
- ✅ Decoupled worker architecture

#### Microservices
- ✅ API Gateway (Go/Gin)
- ✅ Access Worker
- ✅ Dunning Worker
- ✅ Dispute Worker
- ✅ Notification Worker
- ✅ Telegram Bot Service

### 2. Database

#### Database Technology
- ✅ MySQL 8
- ✅ GORM ORM
- ✅ Automatic migrations
- ✅ Database seeding
- ✅ Index optimization

#### Data Models
- ✅ Users & Creators
- ✅ Plans & Subscriptions
- ✅ Members & Buyers
- ✅ Payments & Transactions
- ✅ Channels & Integrations
- ✅ Access Grants & Tokens
- ✅ Scheduled Posts
- ✅ Themes
- ✅ Evidence Storage

### 3. API

#### REST API
- ✅ RESTful endpoints
- ✅ JSON request/response
- ✅ JWT authentication
- ✅ Rate limiting (future)
- ✅ API versioning (v1)

#### API Endpoints
- ✅ **54+ endpoints** total
  - Public endpoints: 12
  - Creator endpoints: 30
  - Admin endpoints: 12

### 4. Webhooks

#### Webhook Features
- ✅ Stripe webhook handling
- ✅ Webhook signature verification
- ✅ Event normalization
- ✅ Idempotent processing
- ✅ Webhook replay
- ✅ Creator-specific webhooks
- ✅ Platform webhooks

### 5. Storage

#### File Storage
- ✅ Persistent storage for uploaded images
- ✅ Evidence file storage
- ✅ Docker volume support
- ✅ Local storage support

### 6. Docker & Deployment

#### Docker Support
- ✅ Docker Compose orchestration
- ✅ Service health checks
- ✅ Volume persistence
- ✅ Network isolation
- ✅ Environment variable management

#### Services
- ✅ Backend API Gateway
- ✅ Frontend (nginx)
- ✅ MySQL Database
- ✅ NATS JetStream
- ✅ Migrate service

### 7. Development Features

#### Development Tools
- ✅ Hot reload (Air for Go)
- ✅ Development Docker Compose
- ✅ Makefile automation
- ✅ Database migrations
- ✅ Seed data generation

---

## Feature Matrix

### By User Type

| Feature Category | Creator | Member | Admin |
|-----------------|---------|--------|-------|
| Authentication | ✅ | ✅ (via Telegram) | ✅ |
| Payment Processing | ✅ | ✅ | ✅ (view) |
| Channel Management | ✅ | ❌ | ✅ (view) |
| Member Management | ✅ | ❌ | ✅ |
| Analytics | ✅ | ❌ | ✅ |
| Theme Management | ❌ | ❌ | ✅ |
| Payment Provider Config | ✅ | ❌ | ✅ |
| Subscription Management | ✅ | ✅ | ✅ (view) |
| Scheduled Posts | ✅ | ❌ | ❌ |
| Access Management | ✅ | ✅ | ❌ |

### By Platform Plan

| Feature | Free | Prime | Pro |
|---------|------|-------|-----|
| Member Transactions/Month | Limited | Higher | Unlimited |
| Channel Integrations | Basic | Advanced | Full |
| Scheduled Posts | ❌ | ✅ | ✅ |
| Advanced Analytics | ❌ | ✅ | ✅ |
| Priority Support | ❌ | ❌ | ✅ |
| Custom Themes | ❌ | ❌ | ✅ (future) |

---

## API Endpoint Summary

### Public Endpoints (12)
- Authentication (3)
- Health & Theme (2)
- Telegram Bot (5)
- Webhooks (2)

### Creator Endpoints (30)
- Plans & Billing (7)
- Integrations (9)
- Scheduled Posts (4)
- Members (2)
- Membership Plans (3)
- Analytics (4)
- Settings (2)
- Theme (1)

### Admin Endpoints (12)
- Creator Management (3)
- Payment Provider Management (3)
- Analytics (2)
- Theme Management (7)

**Total: 54 endpoints**

---

## Database Tables Summary

### Platform Tables
- `users` - Creator accounts
- `creators` - Creator workspaces
- `plans` - Earniqa platform plans
- `plan_prices` - Platform plan pricing
- `subscriptions` - Creator → Earniqa subscriptions
- `admins` - Admin users
- `themes` - Platform themes
- `allowed_payment_providers` - Enabled providers

### Membership Tables
- `buyers` - Member/buyer identities
- `member_subscriptions` - Buyer → Creator subscriptions
- `membership_plans` - Creator-defined plans
- `payments` - Payment records
- `access_grants` - Channel access permissions
- `access_tokens` - Invitation tokens
- `channels` - Creator channels
- `payment_sources` - Creator payment connections
- `scheduled_posts` - Scheduled content

### Supporting Tables
- `channel_imports` - Channel import tracking
- Evidence storage (file-based)

---

## Roadmap & Future Features

### Planned Features
- ✅ Razorpay integration (in progress)
- ✅ PayPal integration
- ✅ Crypto payment support
- ✅ WhatsApp integration
- ✅ Slack integration
- ✅ Multi-language support
- ✅ Custom theme creation (for creators)
- ✅ Advanced fraud detection
- ✅ Member referral program
- ✅ Coupon codes and discounts
- ✅ Usage-based billing
- ✅ White-label solutions
- ✅ Mobile app (iOS/Android)
- ✅ Advanced analytics dashboard
- ✅ Automated marketing campaigns
- ✅ Member engagement analytics

---

## Summary

Earniqa is a comprehensive creator membership platform with:

- **54+ API endpoints** for full platform control
- **4 background workers** for automated processing
- **Multiple payment providers** (Stripe, Razorpay planned, Crypto planned)
- **Multiple channel platforms** (Telegram, Discord, WhatsApp planned, Slack planned)
- **Automated workflows** for access management, dunning, and notifications
- **Fraud detection** and security features
- **Comprehensive analytics** for creators and admins
- **Event-driven architecture** for reliability and scalability
- **Creator-first approach** - payments go directly to creators

The platform is designed to be:
- ✅ **Scalable** - Event-driven, horizontally scalable architecture
- ✅ **Reliable** - Idempotent processing, retry logic, event replay
- ✅ **Secure** - Webhook verification, fraud detection, access control
- ✅ **Creator-friendly** - Direct payments, no escrow, flexible plans
- ✅ **Member-friendly** - Easy checkout, automatic access, bot commands

---

**For API documentation, see:** [ENDPOINT_AND_TABLE_REFERENCE.md](./backend/docs/ENDPOINT_AND_TABLE_REFERENCE.md)

**For setup instructions, see:** [README.md](./README.md)

**For architecture details, see:** [ARCHITECTURE.md](./ARCHITECTURE.md)
