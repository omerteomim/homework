import os
import json
import requests
from flask import Flask, request, jsonify, render_template

app = Flask(__name__)
ROLE_FILE_PATH = "role.txt"


@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")


@app.route("/", methods=["POST"])
def process():
    # 1. Check role file
    if not os.path.exists(ROLE_FILE_PATH):
        return jsonify({"error": "Role file missing"}), 500

    try:
        with open(ROLE_FILE_PATH, "r", encoding="utf-8") as f:
            role = f.read().strip()
    except Exception as e:
        return jsonify({"error": f"Failed to read role file: {str(e)}"}), 500

    # 2. Parse JSON body
    body = request.get_json(silent=True)
    if not body:
        return jsonify({"error": "Invalid JSON in request body"}), 400

    user_text = body.get("text", "")
    user_answer = body.get("answer", "")

    if not user_text:
        return jsonify({"error": "Missing 'text' field"}), 400

    # 3. Get API key
    api_key = os.environ.get("OPENROUTER_API_KEY")
    if not api_key:
        return jsonify({"error": "API key missing"}), 500

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "deepseek/deepseek-chat-v3-0324:free",
        "messages": [
            {"role": "system", "content": role},
            {"role": "user", "content": f"שאלה: {user_text}\nתשובה: {user_answer}"}
        ]
    }

    # 4. Call external API safely
    try:
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            json=payload,
            timeout=30
        )
        response.raise_for_status()
        data = response.json()
    except requests.exceptions.Timeout:
        return jsonify({"error": "External API timeout"})
