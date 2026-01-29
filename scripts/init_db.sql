INSERT INTO dim_website VALUES
(gen_random_uuid(), 'shop.sg', 'ecommerce'),
(gen_random_uuid(), 'gov.sg', 'public');

-- Users
INSERT INTO dim_user VALUES
(gen_random_uuid(), (SELECT website_id FROM dim_website LIMIT 1), 'en', 'SG', 'Chrome', now()),
(gen_random_uuid(), (SELECT website_id FROM dim_website OFFSET 1 LIMIT 1), 'en', 'SG', 'Safari', now());

-- Sessions
INSERT INTO fact_session VALUES
(gen_random_uuid(), (SELECT user_id FROM dim_user LIMIT 1),
 (SELECT website_id FROM dim_website LIMIT 1),
 '192.168.0.12', 'web', 'faq', 'completed',
 '2026-01-22 08:30:00', '2026-01-22 08:45:00', now()),

(gen_random_uuid(), (SELECT user_id FROM dim_user OFFSET 1 LIMIT 1),
 (SELECT website_id FROM dim_website OFFSET 1 LIMIT 1),
 '192.168.0.12', 'web', 'support', 'abandoned',
 '2026-01-22 09:01:15', '2026-01-22 09:05:00', now());
