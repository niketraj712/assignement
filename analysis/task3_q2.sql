
SELECT
    session_id,
    ip_address,
    session_starttstamp,
    LAG(session_endtstamp) OVER (
        PARTITION BY ip_address
        ORDER BY session_starttstamp
    ) AS prev_session_endtstamp,
    EXTRACT(EPOCH FROM (
        session_starttstamp -
        LAG(session_endtstamp) OVER (
            PARTITION BY ip_address
            ORDER BY session_starttstamp
        )
    )) AS idle_time_seconds
FROM fact_session;
