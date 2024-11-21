import logging
import psycopg2
import pandas as pd
import warnings
import json
from sqlalchemy import create_engine
from dotenv import load_dotenv

warnings.filterwarnings("ignore", category=UserWarning)

# Load environment variables (you can remove this if you are hardcoding the connection string)
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.FileHandler("etl_pipeline.log"), logging.StreamHandler()],
)


class ETIPipeline:
    """
    A professional ETI (Extract, Transform, Integrate) pipeline for PostgreSQL data integration.

    This class handles the extraction, transformation, integration, and loading (ETIL) of data
    from PostgreSQL tables into an integrated data warehouse.
    """

    def __init__(self):
        """Initialize the ETI pipeline with database connections."""
        self.postgres_url = self._get_postgres_url()
        self.conn = None
        self.engine = None
        self._connect_to_database()

    @staticmethod
    def _get_postgres_url():
        """Retrieve the PostgreSQL URL from an environment variable or use a hardcoded URL."""
        # You can hardcode the URL here or use an environment variable
        postgres_url = "postgresql://postgres.rmywqhaxmkpxmfkzyczn:e9Ty!d_W3m-Fu-U@aws-0-eu-central-1.pooler.supabase.com:6543/postgres"
        return postgres_url

    def _connect_to_database(self):
        """Establish connections to PostgreSQL database."""
        try:
            logging.info("Establishing database connections...")
            self.conn = psycopg2.connect(self.postgres_url)
            self.engine = create_engine(self.postgres_url)
            logging.info("Database connections established successfully.")
        except Exception as e:
            logging.error(f"Failed to connect to the database: {e}")
            raise

    def upload_csv_to_db(self, csv_file_path, table_name):
        """
        Upload a CSV file to a specified PostgreSQL table.

        Args:
            csv_file_path (str): The file path of the CSV to be uploaded.
            table_name (str): The target table name in the PostgreSQL database.
        """
        try:
            logging.info(f"Starting CSV upload from {csv_file_path} to table {table_name}...")

            # Read the CSV into a DataFrame
            df = pd.read_csv(csv_file_path)

            # Upload DataFrame to PostgreSQL
            df.to_sql(table_name, self.engine, if_exists='replace', index=False)

            logging.info(f"CSV uploaded successfully to table {table_name}.")
        except Exception as e:
            logging.error(f"Error during CSV upload: {e}")
            raise

    def upload_json_to_db(self, json_file_path, table_name):
        """
        Upload a JSON file to a specified PostgreSQL table.

        Args:
            json_file_path (str): The file path of the JSON to be uploaded.
            table_name (str): The target table name in the PostgreSQL database.
        """
        try:
            logging.info(f"Starting JSON upload from {json_file_path} to table {table_name}...")

            # Read the JSON into a DataFrame
            with open(json_file_path, 'r') as json_file:
                data = json.load(json_file)

            # Convert the JSON data into a DataFrame
            df = pd.json_normalize(data)

            # Upload DataFrame to PostgreSQL
            df.to_sql(table_name, self.engine, if_exists='replace', index=False)

            logging.info(f"JSON uploaded successfully to table {table_name}.")
        except Exception as e:
            logging.error(f"Error during JSON upload: {e}")
            raise

    def upload_sql_to_db(self, sql_file_path):
        """
        Upload SQL file to PostgreSQL database.

        Args:
            sql_file_path (str): The file path of the SQL to be executed.
        """
        try:
            logging.info(f"Starting SQL upload from {sql_file_path}...")

            # Read the SQL file
            with open(sql_file_path, 'r') as sql_file:
                sql_script = sql_file.read()

            # Execute the SQL script
            with self.conn.cursor() as cursor:
                cursor.execute(sql_script)
                self.conn.commit()

            logging.info(f"SQL uploaded successfully from {sql_file_path}.")
        except Exception as e:
            logging.error(f"Error during SQL upload: {e}")
            raise

    def extract_data(self, tables):
        """
        Extract data from specified PostgreSQL tables.

        Args:
            tables (list): List of table names to extract data from.

        Returns:
            dict: A dictionary of pandas DataFrames representing each table.
        """
        try:
            logging.info(f"Starting data extraction for tables: {', '.join(tables)}...")
            data = {
                table: pd.read_sql_query(f"SELECT * FROM {table}", self.conn) for table in tables
            }
            logging.info(f"Data extraction completed successfully for tables: {', '.join(tables)}.")
            return data
        except Exception as e:
            logging.error(f"Error during data extraction: {e}")
            raise

    @staticmethod
    def transform_data(data):
        """
        Transform extracted data by performing necessary cleaning and transformations.

        Args:
            data (dict): A dictionary containing pandas DataFrames for each table.

        Returns:
            dict: A dictionary containing the transformed DataFrames.
        """
        try:
            logging.info("Starting data transformation...")

            # Example transformation: normalize the 'username' field to lowercase in DimUser
            if "DimUser" in data:
                data["DimUser"]['username'] = data["DimUser"]['username'].str.lower()

            # Remove duplicates across all dataframes
            data = {key: df.drop_duplicates() for key, df in data.items()}

            logging.info("Data transformation completed successfully.")
            return data
        except Exception as e:
            logging.error(f"Error during data transformation: {e}")
            raise

    @staticmethod
    def integrate_data(data, integration_map):
        """
        Integrate transformed data into a single cohesive DataFrame by merging the tables.

        Args:
            data (dict): A dictionary of transformed DataFrames.
            integration_map (list): A list of dictionaries defining how to merge the tables.

        Returns:
            pd.DataFrame: The integrated DataFrame.
        """
        try:
            logging.info("Starting data integration...")
            integrated_df = None

            for step in integration_map:
                left_table = step["left"]
                right_table = step["right"]
                on = step["on"]
                how = step.get("how", "inner")

                if left_table not in data or right_table not in data:
                    raise ValueError(f"Missing table(s) for integration: {left_table}, {right_table}")

                # Perform the first merge if the integrated_df is None, otherwise continue merging
                if integrated_df is None:
                    integrated_df = pd.merge(data[left_table], data[right_table], on=on, how=how)
                else:
                    integrated_df = pd.merge(integrated_df, data[right_table], on=on, how=how)

            logging.info("Data integration completed successfully.")
            return integrated_df
        except Exception as e:
            logging.error(f"Error during data integration: {e}")
            raise

    def load_data(self, integrated_df):
        """
        Load the integrated data into the PostgreSQL warehouse table.

        Args:
            integrated_df (pd.DataFrame): The integrated DataFrame to load into the warehouse.
        """
        try:
            logging.info("Starting data load into the warehouse...")
            integrated_df.to_sql('IntegratedDataWarehouse', self.engine, if_exists='replace', index=False)
            logging.info("Data loaded successfully into IntegratedDataWarehouse.")
        except Exception as e:
            logging.error(f"Error during data load: {e}")
            raise

    def run_pipeline(self, tables, integration_map):
        """
        Execute the full ETI pipeline (Extract, Transform, Integrate, Load).

        Args:
            tables (list): List of table names to extract data from.
            integration_map (list): List of dictionaries defining the integration logic.
        """
        try:
            logging.info("Running the ETI pipeline...")

            # Step 1: Extract data
            data = self.extract_data(tables)

            # Step 2: Transform data
            transformed_data = self.transform_data(data)

            # Step 3: Integrate data
            integrated_df = self.integrate_data(transformed_data, integration_map)

            # Step 4: Load data into warehouse
            self.load_data(integrated_df)

            logging.info("ETI pipeline completed successfully.")
        finally:
            self._close_connections()

    def _close_connections(self):
        """Close the database connections."""
        if self.conn:
            self.conn.close()
            logging.info("Database connection closed.")


if __name__ == "__main__":
    # Path to the CSV file and target table
    csv_file_path = "user_data_100_extended.csv"
    json_file_path = "user_data_100_extended.json"
    sql_file_path = "users.sql"
    target_table = "DimUser"  # The name of the table where the data should be uploaded

    # Instantiate the pipeline and upload CSV data to PostgreSQL
    pipeline = ETIPipeline()
    pipeline.upload_csv_to_db(csv_file_path, target_table)
    pipeline.upload_json_to_db(json_file_path, target_table)
    pipeline.upload_sql_to_db(sql_file_path)

    # Define tables and integration logic
    tables = ["DimUser", "FactTransaction", "FactVirtualCard"]
    integration_map = [
        {"left": "FactTransaction", "right": "DimUser", "on": "user_id", "how": "inner"},
        {"left": "FactTransaction", "right": "FactVirtualCard", "on": "user_id", "how": "left"},
    ]

    # Run the full ETI pipeline
    pipeline.run_pipeline(tables, integration_map)
