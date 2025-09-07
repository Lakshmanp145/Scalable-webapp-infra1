from flask import Flask
import psycopg2
import os

app = Flask(__name__)

# RDS connection details from environment variables
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME", "mydb")
DB_USER = os.getenv("DB_USER", "dbuser")
DB_PASS = os.getenv("DB_PASS")

@app.route("/")
def home():
    try:
        conn = psycopg2.connect(
            host=DB_HOST, database=DB_NAME,
            user=DB_USER, password=DB_PASS
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        db_version = cur.fetchone()
        cur.close()
        conn.close()
        return f"<h1>Flask App Connected to RDS</h1><p>PostgreSQL Version: {db_version}</p>"
    except Exception as e:
        return f"<h1>Database connection failed</h1><pre>{e}</pre>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
