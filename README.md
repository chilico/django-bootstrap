# django-asgi

This is a Django repo for bootstrapping, running the ASGI server.

It may act as a template to get a dockerised async Django backend setup quickly.

### Setup & start

```sh
docker compose build
docker compose up
```

### Database Configuration

The project includes two PostgreSQL database services:

- **django_db** (port 5432): Main development database
  - User: `django`
  - Password: `django`
  - Database: `django`

- **django_db_test** (port 5433): Test database
  - User: `django_test`
  - Password: `django_test`
  - Database: `django_test`

To run tests against the test database, set the `TEST_DATABASE_URL` environment variable:
```sh
TEST_DATABASE_URL=postgresql://django_test:django_test@django_db_test:5432/django_test
```

Made by @chilico
