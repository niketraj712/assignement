Task 2 — Success Metrics
2.1 Proposed Metrics
Metric 1: Completion Rate

Definition: % of sessions with status = 'completed'

Why: Measures task success without user surveys
Signals: session status
Validation: filter bot IPs, min session duration > 10s
==================================================================================
Metric 2: Avg Agent Response Time

Definition: Avg time between user message and next agent reply

Why: Proxy for responsiveness
Signals: message timestamps
Validation: exclude system messages, cap outliers
=========================================================================
Metric 3: Short Conversation Rate

Definition: Sessions with < 3 messages OR duration < 60s

Why: Drop-off / dissatisfaction signal
Signals: message counts, session duration
Validation: exclude test users, language filters
========================================================================

fact_session_metrics
CREATE TABLE fact_session_metrics (
    conversation_id UUID PRIMARY KEY,
    website_id UUID,

    session_duration_seconds INTEGER,
    total_messages INTEGER,

    is_completed BOOLEAN,
    is_escalated BOOLEAN,
    is_short_conversation BOOLEAN,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Aggregation Logic
INSERT INTO fact_session_metrics
SELECT
    c.conversation_id,
    c.website_id,

    EXTRACT(EPOCH FROM (c.session_end_ts - c.session_start_ts))::INT AS session_duration_seconds,
    COUNT(m.message_id) AS total_messages,

    c.status = 'completed' AS is_completed,
    c.status = 'escalated' AS is_escalated,

    (COUNT(m.message_id) < 3
     OR EXTRACT(EPOCH FROM (c.session_end_ts - c.session_start_ts)) < 60)
        AS is_short_conversation
FROM fact_conversation c
LEFT JOIN fact_message m
  ON c.conversation_id = m.conversation_id
GROUP BY c.conversation_id, c.website_id, c.status, c.session_start_ts, c.session_end_ts;

 
