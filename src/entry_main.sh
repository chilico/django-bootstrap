#!/bin/bash
set -e

# configuration from env vars
PROJECT_NAME=${DJANGO_PROJECT_NAME:-project}
WORKERS=${WORKERS:-1}
PORT=${PORT:-8080}
RELOAD=${DEBUG:-0}

echo "Waiting for PostgreSQL to be ready ..."
while ! nc -z django_db 5432; do
  sleep 0.1
done

# create project if missing / first initialisation
if [ ! -f "$PROJECT_NAME/settings.py" ]; then
  echo "No Django project found. Creating '$PROJECT_NAME' ..."
  django-admin startproject $PROJECT_NAME .
fi

echo "Running Migrations..."
python manage.py migrate --noinput

echo "Starting Django App with Uvicorn (ASGI) ..."
if [ "$RELOAD" = 1 ]; then
  # running dev, so only use one worker
  uvicorn ${PROJECT_NAME}.asgi:application --host 0.0.0.0 --port $PORT --reload
else
  uvicorn ${PROJECT_NAME}.asgi:application --host 0.0.0.0 --port $PORT --workers $WORKERS
fi
