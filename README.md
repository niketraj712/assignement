Chatbot Conversation Analytics — Data Engineering Assessment
Overview

This repository contains an end-to-end data engineering solution for storing, processing, and analysing conversational chatbot data. The solution is designed to support a chatbot service embedded across multiple websites in Singapore, with a focus on:

Reliable storage of conversation and message-level logs

Analytics-ready data models for session and message analysis

Quantifiable success metrics to evaluate chatbot performance

Reproducible local setup using containerised infrastructure

The implementation uses PostgreSQL, SQL, and Python, and follows a clear separation between raw events, core fact tables, and aggregated analytics tables.

Scope of Work

This project addresses the following tasks:

Data Modelling & Core Tables

User, website, session, and message-level data storage

Normalised relational schema

Sample synthetic data for validation

Success Metrics Design

Definition of key chatbot success metrics

Aggregated session-level metrics tables

Data Analysis (SQL)

Behavioural analysis queries for session duration, idle time, conversation quality, and peak traffic

Architecture Overview
Raw Events (messages, sessions)
        |
        v
Core Fact Tables
(fact_session, fact_message)
        |
        v
Aggregated Metrics
(session_metrics)
        |
        v
Analytics & SQL Reporting


The design prioritises:

Simplicity and clarity

Analytics correctness

Extensibility for future NLP enrichment or scaling

Repository Structure
.
├── README.md                       # Project overview and instructions
├── docker-compose.yaml             # Local Postgres setup
├── scripts/
│   ├── init_db.sql                 # DDL and synthetic sample data
│   ├── data_transformation.sql     # Aggregation logic for metrics
│   └── pipeline.py                 # Optional Python ingestion example
├── analysis/
│   ├── task3_q1.sql                # Long sessions by IP
│   ├── task3_q2.sql                # Idle time between sessions
│   ├── task3_q3.sql                # Conversation quality signals
│   └── task3_q4.sql                # Peak traffic & concurrency
├── sample_data/
│   └── mock_messages.csv           # Synthetic message-level data
└── docs/
    ├── data_model.md               # Data model rationale
    └── success_metrics.md          # Metric definitions & assumptions

Setup Instructions
Prerequisites

Docker & Docker Compose

(Optional) Python 3.9+ if running the ingestion script

Start the Database
docker-compose up -d


This will:

Start a local PostgreSQL instance

Automatically execute scripts/init_db.sql

Create tables and insert synthetic sample data

Verify Setup
psql -h localhost -U chatbot -d chatbot_analytics

Data Model Summary
Core Tables

dim_website — Website metadata

dim_user — User-level attributes

fact_session — Conversation/session lifecycle

fact_message — Message-level interaction logs

Analytics Tables

session_metrics — Aggregated session-level metrics for analysis

Detailed design rationale and trade-offs are documented in docs/data_model.md.

Success Metrics

The following metrics are proposed to evaluate chatbot effectiveness:

Conversation Completion Rate

Percentage of sessions completed successfully

Average Agent Response Time

Proxy for responsiveness and usability

Short Conversation Rate

Indicator of potential drop-offs or poor user experience

Metric definitions, required signals, validation considerations, and assumptions are documented in docs/success_metrics.md.

Data Analysis Queries

The analysis/ folder contains SQL queries addressing the following:

Identification of IPs with long average session durations

Idle time between sessions by IP

Short conversation analysis by website

Hourly traffic and concurrency patterns

Each query is written using standard PostgreSQL syntax and is documented with inline comments.

Assumptions

All timestamps are stored in UTC

IP addresses are IPv4 only

Synthetic data does not include bot or test traffic

Sessions have a single contiguous start and end timestamp

Message timestamps fall within their session window

Known Limitations

Overlapping sessions from the same IP are not explicitly resolved

Bot traffic detection is out of scope

NLP fields are optional and sparsely populated in sample data

Concurrency calculation is an approximation based on session windows

Potential Enhancements

Bot and test traffic filtering

Incremental ingestion and late-arriving event handling

Partitioning by date for large-scale deployments

Integration with dbt for transformation management

Additional feedback or escalation signals

Conclusion

This solution demonstrates a pragmatic and scalable approach to chatbot conversation analytics, balancing clarity, correctness, and extensibility. The data model and metrics are designed to support both operational monitoring and longer-term product insights.
