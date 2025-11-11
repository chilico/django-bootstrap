#!/bin/bash
set -e

PROJECT_DIR="./project"

# create project if missing
if [ ! -f "$PROJECT_DIR/settings.py" ]; then
  echo "No Django project found. Creating one at $PROJECT_DIR..."
  django-admin startproject project .
fi

echo "Waiting for PostgreSQL to be ready..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "PostgreSQL is ready!"

echo "Running Migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "Starting Django App with Uvicorn (ASGI)..."

# replace 'project' with your actual Django project name
uvicorn project.asgi:application --host 0.0.0.0 --port 8080 --workers 3 --log-level info
