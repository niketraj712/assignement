import pandas as pd
import psycopg2

df = pd.read_csv("sample_data/mock_messages.csv")

conn = psycopg2.connect(
    dbname="chatbot_analytics",
    user="chatbot",
    password="chatbot",
    host="localhost"
)

df.to_sql("fact_message", conn, if_exists="append", index=False)
