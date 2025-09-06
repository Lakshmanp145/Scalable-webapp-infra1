from flask import Flask, jsonify
import os
import psycopg2
import time

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST")
DB_NAME = os.environ.get("DB_NAME")
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
DB_PORT = int(os.environ.get("DB_PORT", 5432))

def get_db_connection():
    attempts = 0
    while attempts < 5:
        try:
            conn = psycopg2.connect(
                host=DB_HOST,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                port=DB_PORT,
                connect_timeout=5
            )
            return conn
        except Exception:
            attempts += 1
            time.sleep(2)
    raise RuntimeError("Could not connect to DB")

@app.route("/")
def index():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT NOW();")
        result = cur.fetchone()
        cur.close()
        conn.close()
        return f"Hello! DB time: {result[0]}", 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/health")
def health():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({"status": "healthy"}), 200
    except Exception:
        return jsonify({"status": "unhealthy"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
