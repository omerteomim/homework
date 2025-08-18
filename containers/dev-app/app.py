import os
import json
import requests
from flask import Flask, request, jsonify, render_template
import traceback

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
        traceback.print_exc()
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
        traceback.print_exc()
        return jsonify({"error": "External API timeout"}), 504
    except requests.exceptions.HTTPError as e:
        traceback.print_exc()
        return jsonify({"error": f"External API HTTP error: {e}"}), 502
    except requests.exceptions.RequestException as e:
        traceback.print_exc()
        return jsonify({"error": f"External API request failed: {e}"}), 502
    except json.JSONDecodeError:
        traceback.print_exc()
        return jsonify({"error": "Invalid JSON returned from API"}), 502
    except Exception as e:
        traceback.print_exc()
        return jsonify({"error": f"Unexpected error: {str(e)}"}), 500

    # 5. Extract the result safely
    choices = data.get("choices")
    if not choices or len(choices) == 0:
        return jsonify({"error": "No choices returned from API"}), 502

    result = choices[0].get("message", {}).get("content", "")
    if not result:
        return jsonify({"error": "Empty response from API"}), 502

    return jsonify({"result": result, "text": user_text, "answer": user_answer}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 80)), debug=True)
