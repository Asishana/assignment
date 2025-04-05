import datetime
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def server_time():
    utc_now = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    return jsonify(server_time=utc_now)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
