from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/search', methods=['POST'])
def search():
    tag = request.form['tags']

    # Check if the tag is valid
    if tag.isalnum() or '-' in tag:
        try:
            # Call the shell script with user input using subprocess.run
            result = subprocess.run(['./waifu_search.sh', tag], check=True, capture_output=True, text=True)
            output = result.stdout
            error = result.stderr

            # Print the output and error for debugging
            print("Output:", output)
            print("Error:", error)
        except subprocess.CalledProcessError as e:
            # Print the error message to the console for further inspection
            print("Error:", e.stderr)
            # Pass a generic error message to the template
            return render_template('error.html', error="An error occurred. Check the console for more details.")

        # Pass the result to the template
        return render_template('result.html', result=output)
    else:
        # If the tag is not valid
        return render_template('error.html', error="Error: Tags must consist of alphanumeric characters or hyphens only.")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
