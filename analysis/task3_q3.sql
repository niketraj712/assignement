
WITH session_stats AS (
    SELECT
        s.session_id,
        s.website_id,
        s.ip_address,
        s.session_starttstamp,
        COUNT(m.message_id) AS total_messages,
        EXTRACT(EPOCH FROM (s.session_endtstamp - s.session_starttstamp)) AS duration_sec,
        CASE
            WHEN COUNT(m.message_id) < 3 OR
                 EXTRACT(EPOCH FROM (s.session_endtstamp - s.session_starttstamp)) < 60
            THEN 1 ELSE 0
        END AS is_short
    FROM fact_session s
    LEFT JOIN fact_message m ON s.session_id = m.session_id
    GROUP BY s.session_id, s.website_id, s.ip_address, s.session_starttstamp, s.session_endtstamp
)
SELECT
    w.website_domain,
    COUNT(*) AS total_sessions,
    SUM(is_short) AS short_sessions,
    ROUND(100.0 * SUM(is_short) / COUNT(*), 2) AS pct_short_sessions
FROM session_stats ss
JOIN dim_website w ON ss.website_id = w.website_id
GROUP BY w.website_domain;
