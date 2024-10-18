FROM python:alpine

# Set the working directory
WORKDIR /app

# Install git
RUN apk add --no-cache git

# Clone the repository
RUN git clone https://github.com/bassma-khaled14/Note-App.git .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install gunicorn prometheus-flask-exporter

# Expose the port on which the application will run
EXPOSE 5000

# Use gunicorn to run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

