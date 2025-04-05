import datetime
from flask import Flask

app = Flask(__name__)

@app.route("/")
def server_time():
    return {"server_time": datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")}
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)