====== Core Tables=====
Dimension Tables
dim_website
CREATE TABLE dim_website (
    website_id UUID PRIMARY KEY,
    website_domain TEXT NOT NULL UNIQUE,
    industry TEXT,
    created_at TIMESTAMP DEFAULT now()
);

dim_user
CREATE TABLE dim_user (
    user_id UUID PRIMARY KEY,
    website_id UUID REFERENCES dim_website(website_id),
    language TEXT,
    country TEXT,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT now()
);

Fact Tables
fact_session
CREATE TABLE fact_session (
    session_id UUID PRIMARY KEY,
    user_id UUID REFERENCES dim_user(user_id),
    website_id UUID REFERENCES dim_website(website_id),
    ip_address VARCHAR(15),
    channel TEXT,
    intent TEXT,
    status TEXT,
    session_starttstamp TIMESTAMP NOT NULL,
    session_endtstamp TIMESTAMP,
    created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_session_ip ON fact_session(ip_address);
CREATE INDEX idx_session_start ON fact_session(session_starttstamp);

fact_message
CREATE TABLE fact_message (
    message_id UUID PRIMARY KEY,
    session_id UUID REFERENCES fact_session(session_id),
    sender_type TEXT CHECK (sender_type IN ('user','agent')),
    message_tstamp TIMESTAMP NOT NULL,
    content TEXT,
    content_type TEXT,
    intent TEXT,
    sentiment_score NUMERIC(4,2),
    created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_message_session ON fact_message(session_id);
CREATE INDEX idx_message_time ON fact_message(message_tstamp);
