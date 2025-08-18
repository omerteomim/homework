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
    try:
        with open(ROLE_FILE_PATH, "r", encoding="utf-8") as f:
            role = f.read().strip()

        body = request.get_json(force=True)
        user_text = body.get("text", "")
        user_answer = body.get("answer", "")

        headers = {
            "Authorization": f"Bearer {os.environ['OPENROUTER_API_KEY']}",
            "Content-Type": "application/json"
        }

        payload = {
            "model": "deepseek/deepseek-chat-v3-0324:free",
            "messages": [
                {"role": "system", "content": role},
                {"role": "user", "content": f"שאלה: {user_text}\nתשובה: {user_answer}"}
            ]
        }

        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            json=payload,
            timeout=30
        )
        data = response.json()
        result = data["choices"][0]["message"]["content"]

        return jsonify({"result": result, "text": user_text, "answer": user_answer}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 80)))
    