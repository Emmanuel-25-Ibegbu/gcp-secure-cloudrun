import os
import time

from flask import Flask, jsonify

app = Flask(__name__)

FAULTS_ENABLED = os.environ.get("ENABLE_FAULT_INJECTION") == "true"


@app.get("/health")
def health():
    return jsonify(status="ok"), 200


@app.get("/api/v1/status")
def status():
    # Never return the secret. Only confirm it loaded.
    return jsonify(
        service="secure-api",
        version=os.environ.get("K_REVISION", "local"),
        payment_key_loaded=bool(os.environ.get("PAYMENT_API_KEY")),
    ), 200


# Test-only routes for alert testing. Off unless the flag is set.
@app.get("/api/v1/fault/error")
def fault_error():
    if not FAULTS_ENABLED:
        return jsonify(error="not found"), 404
    return jsonify(error="simulated failure"), 500


@app.get("/api/v1/fault/slow")
def fault_slow():
    if not FAULTS_ENABLED:
        return jsonify(error="not found"), 404
    time.sleep(3)
    return jsonify(status="slow ok"), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
