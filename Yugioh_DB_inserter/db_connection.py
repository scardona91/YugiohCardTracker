from sqlalchemy import create_engine
from sqlalchemy.pool import NullPool


class DbConnection:

    @staticmethod
    def get_connection(user, password, db):
        connection_string = f"mysql+mysqlconnector://{user}:{password}@localhost/{db}"
        db = create_engine(connection_string, poolclass=NullPool)
        return db.raw_connection()
