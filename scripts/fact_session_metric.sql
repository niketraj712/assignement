Aggregated Metrics Table
session_metrics
CREATE TABLE session_metrics AS
SELECT
    s.session_id,
    s.website_id,
    s.ip_address,
    COUNT(m.message_id) AS total_messages,
    EXTRACT(EPOCH FROM (s.session_endtstamp - s.session_starttstamp)) AS session_duration_sec,
    CASE
        WHEN COUNT(m.message_id) < 3
          OR EXTRACT(EPOCH FROM (s.session_endtstamp - s.session_starttstamp)) < 60
        THEN TRUE ELSE FALSE
    END AS is_short_conversation
FROM fact_session s
LEFT JOIN fact_message m ON s.session_id = m.session_id
GROUP BY s.session_id, s.website_id, s.ip_address, s.session_starttstamp, s.session_endtstamp;
