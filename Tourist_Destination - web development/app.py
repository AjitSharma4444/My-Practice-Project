from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/business')
def business():
    return render_template('business.html')

@app.route('/environment')
def environment():
    return render_template('environment.html')

if __name__ == '__main__':
    app.run(debug=True)
