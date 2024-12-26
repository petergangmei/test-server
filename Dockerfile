# Use Python image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    musl-dev \
    libpq-dev \
    && apt-get clean

# Install Python dependencies
COPY ./app/requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY ./app /app/

# Collect static files
# RUN python manage.py collectstatic --noinput

# Expose port 8000
EXPOSE 8000

# Start Gunicorn server
# CMD ["gunicorn", "--workers=3", "--bind", "0.0.0.0:8000", "core.wsgi:application"]
CMD ["gunicorn", "--workers=4", "--threads=2", "--timeout=60", "--bind=0.0.0.0:8000", "core.wsgi:application"]
