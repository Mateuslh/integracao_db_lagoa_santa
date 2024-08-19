import os
from contextlib import contextmanager

import psycopg2
import psycopg2.extras
from dotenv import load_dotenv
from psycopg2 import pool

load_dotenv()

DB_PARAMS = {
    'dbname': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'host': os.getenv('DB_HOST'),
    'port': os.getenv('DB_PORT')
}


connection_pool = pool.SimpleConnectionPool(
    1, 20,
    **DB_PARAMS
)


@contextmanager
def get_db_connection():
    """
    Context manager to get a database connection from the pool.
    Ensures that the connection is returned to the pool after use.
    """
    conn = None
    try:
        conn = connection_pool.getconn()
        yield conn
    except psycopg2.DatabaseError as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if conn:
            connection_pool.putconn(conn)


def execute_query(query, params=None):
    """
    Execute a single query without returning any result.
    :param query: SQL query to be executed.
    :param params: Parameters to be passed to the SQL query.
    """
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            try:
                cur.execute(query, params)
                conn.commit()
            except Exception as e:
                conn.rollback()
                print(f"Failed to execute query: {e}")


def fetch_results(query, params=None):
    """
    Execute a query and fetch all results.
    :param query: SQL query to be executed.
    :param params: Parameters to be passed to the SQL query.
    :return: List of fetched results.
    """
    with get_db_connection() as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
            try:
                cur.execute(query, params)
                return cur.fetchall()
            except Exception as e:
                print(f"Failed to fetch results: {e}")
                return []


def execute_transaction(queries):
    """
    Execute multiple queries as a single transaction.
    :param queries: List of tuples containing SQL queries and their parameters.
    """
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            try:
                for query, params in queries:
                    cur.execute(query, params)
                conn.commit()
            except Exception as e:
                conn.rollback()
                print(f"Transaction failed: {e}")


def close_connection_pool():
    """
    Close all connections in the pool.
    """
    connection_pool.closeall()


def update_sit_protocolo(protocolo, situacao):
    execute_query('''UPDATE protocolo SET situacao = %s where protocolo_id = %s''',
                  params=(situacao, protocolo))
