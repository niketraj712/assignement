SELECT
    ip_address,
    AVG(session_duration_sec) / 60 AS avg_duration_minutes
FROM session_metrics
GROUP BY ip_address
HAVING AVG(session_duration_sec) > 900;
