import pytest

from django.db import connections
from django.test import AsyncClient


@pytest.fixture
def async_client():
    """Fixture providing an async test client"""
    return AsyncClient()


@pytest.fixture(autouse=True)
def close_db_connections():
    """Ensure all database connections are closed after each test"""
    yield
    for conn in connections.all():
        conn.close()
