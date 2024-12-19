from flask import Flask, request, render_template
import subprocess
import os

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/check_broken_images', methods=['POST'])
def check_broken_images():
    website_url = request.form['website_url']

    # Run the Robot Framework script
    result = run_robot_script(website_url)

    return render_template('result.html', result=result)


def run_robot_script(url):
    # Run the Robot Framework script through subprocess
    command = f"robot --variable URL:{url} your_script.robot"
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()

    # Capture the output (stdout) and return it to display on the webpage
    if process.returncode == 0:
        return stdout.decode('utf-8')  # Return the Robot Framework output
    else:
        return f"Error: {stderr.decode('utf-8')}"


if __name__ == "__main__":
    app.run(debug=True)
