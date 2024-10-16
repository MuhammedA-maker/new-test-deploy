from flask import Flask, request, render_template, redirect, url_for
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)  # Initialize PrometheusMetrics after Flask app

notes = []

@app.route('/')
def index():
    return render_template('index.html', notes=notes)

@app.route('/add', methods=['POST'])
def add():
    note = request.form['note']
    if note:
        notes.append(note)
    return redirect(url_for('index'))

@app.route('/delete/<int:note_id>')
def delete(note_id):
    if 0 <= note_id < len(notes):
        notes.pop(note_id)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
