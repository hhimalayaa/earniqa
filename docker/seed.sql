-- Comprehensive Seed Data for Earniqa API
-- This file contains seed data for all API endpoints
-- Run this after migrations to populate the database with test data

-- ============================================================================
-- 1. ADMIN USERS
-- ============================================================================
INSERT INTO `admins` (`email`, `password_hash`, `is_super_admin`, `status`, `created_at`, `updated_at`)
VALUES 
    ('admin@earniqa.com', '$2a$10$uhQhKJjz.2V2/mSDylx4iuAeUGYUw0f3AWb.yot7pdWilGNw.CXmC', true, 'active', NOW(), NOW()),
    ('admin2@earniqa.com', '$2a$10$uhQhKJjz.2V2/mSDylx4iuAeUGYUw0f3AWb.yot7pdWilGNw.CXmC', false, 'active', NOW(), NOW())
ON DUPLICATE KEY UPDATE `updated_at` = NOW();


-- ============================================================================
-- 13. THEMES (Enhanced - additional themes)
-- ============================================================================
-- Dark theme
INSERT INTO `themes` (`id`, `name`, `colors`, `images`, `font_family`, `border_radius`, `is_active`, `created_at`, `updated_at`)
VALUES 
    ('dark-theme', 'Dark Theme', 
     CAST('{"primary":{"50":"#1e293b","100":"#334155","200":"#475569","300":"#64748b","400":"#94a3b8","500":"#cbd5e1","600":"#e2e8f0","700":"#f1f5f9","800":"#f8fafc","900":"#ffffff"},"secondary":{"50":"#0f172a","100":"#1e293b","200":"#334155","300":"#475569","400":"#64748b","500":"#94a3b8","600":"#cbd5e1","700":"#e2e8f0","800":"#f1f5f9","900":"#f8fafc"},"success":{"50":"#064e3b","100":"#065f46","200":"#047857","300":"#059669","400":"#10b981","500":"#34d399","600":"#6ee7b7","700":"#a7f3d0","800":"#d1fae5","900":"#ecfdf5"},"warning":{"50":"#78350f","100":"#92400e","200":"#b45309","300":"#d97706","400":"#f59e0b","500":"#fbbf24","600":"#fcd34d","700":"#fde68a","800":"#fef3c7","900":"#fffbeb"},"danger":{"50":"#7f1d1d","100":"#991b1b","200":"#b91c1c","300":"#dc2626","400":"#ef4444","500":"#f87171","600":"#fca5a5","700":"#fecaca","800":"#fee2e2","900":"#fef2f2"}}' AS JSON),
     CAST('{"logo":"https://example.com/logo-dark.png","favicon":"https://example.com/favicon-dark.ico"}' AS JSON),
     'Inter, system-ui, sans-serif', '8px', false, NOW(), NOW()),
    ('light-theme', 'Light Theme',
     CAST('{"primary":{"50":"#eff6ff","100":"#dbeafe","200":"#bfdbfe","300":"#93c5fd","400":"#60a5fa","500":"#3b82f6","600":"#2563eb","700":"#1d4ed8","800":"#1e40af","900":"#1e3a8a"},"secondary":{"50":"#f9fafb","100":"#f3f4f6","200":"#e5e7eb","300":"#d1d5db","400":"#9ca3af","500":"#6b7280","600":"#4b5563","700":"#374151","800":"#1f2937","900":"#111827"},"success":{"50":"#f0fdf4","100":"#dcfce7","200":"#bbf7d0","300":"#86efac","400":"#4ade80","500":"#22c55e","600":"#16a34a","700":"#15803d","800":"#166534","900":"#14532d"},"warning":{"50":"#fffbeb","100":"#fef3c7","200":"#fde68a","300":"#fcd34d","400":"#fbbf24","500":"#f59e0b","600":"#d97706","700":"#b45309","800":"#92400e","900":"#78350f"},"danger":{"50":"#fef2f2","100":"#fee2e2","200":"#fecaca","300":"#fca5a5","400":"#f87171","500":"#ef4444","600":"#dc2626","700":"#b91c1c","800":"#991b1b","900":"#7f1d1d"}}' AS JSON),
     CAST('{"logo":"https://example.com/logo-light.png","favicon":"https://example.com/favicon-light.ico"}' AS JSON),
     'Inter, system-ui, sans-serif', '8px', false, NOW(), NOW())
ON DUPLICATE KEY UPDATE `updated_at` = NOW();

-- ============================================================================
-- SEED DATA SUMMARY
-- ============================================================================
-- This seed file creates:
-- - 2 Admin users (1 super admin, 1 regular admin)
-- - 5 Users and Creators (with different plans: free, prime, pro)
-- - 5 Subscriptions (linking creators to plans)
-- - 10 Buyers/Members
-- - 10 Member Subscriptions (various statuses: active, past_due, expired, canceled)
-- - 10 Payments (various types: succeeded, failed, refunded)
-- - 5 Payment Sources (Stripe, Razorpay)
-- - 7 Channels (Telegram, Discord)
-- - 7 Membership Plans (creator-defined plans)
-- - 11 Access Grants (linking members to channels)
-- - 5 Scheduled Posts (various statuses)
-- - 4 Allowed Payment Providers
-- - 2 Additional Themes (Dark, Light)
-- - 5 Access Tokens (for member invitations)
--
-- All data is properly linked with foreign keys and realistic relationships.
-- Password for all users: admin123 (bcrypt hash: $2a$10$uhQhKJjz.2V2/mSDylx4iuAeUGYUw0f3AWb.yot7pdWilGNw.CXmC)

