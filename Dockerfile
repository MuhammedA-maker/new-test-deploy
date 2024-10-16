FROM python:alpine

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install gunicorn prometheus-flask-exporter

# Copy the application code
COPY . .

# Expose the port on which the application will run
EXPOSE 5000

# Use gunicorn to run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
