WITH hours AS (
    SELECT generate_series(
        '2026-01-22 00:00:00'::timestamp,
        '2026-01-22 23:00:00'::timestamp,
        interval '1 hour'
    ) AS hour_bucket
)
SELECT
    h.hour_bucket,
    COUNT(s.session_id) FILTER (
        WHERE date_trunc('hour', s.session_starttstamp) = h.hour_bucket
    ) AS sessions_started,
    COUNT(s.session_id) FILTER (
        WHERE s.session_starttstamp <= h.hour_bucket
          AND s.session_endtstamp >= h.hour_bucket
    ) AS active_sessions
FROM hours h
LEFT JOIN fact_session s ON TRUE
GROUP BY h.hour_bucket
ORDER BY h.hour_bucket;

