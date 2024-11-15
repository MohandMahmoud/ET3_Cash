import psycopg2
import pandas as pd
from sqlalchemy import create_engine
import warnings


warnings.filterwarnings("ignore", category=UserWarning)

# PostgreSQL's connection details (replace with your actual credentials)
# Example from a free PostgreSQL provider (e.g., Heroku, ElephantSQL, Railway, etc.)
postgres_url = "postgresql://postgres.rmywqhaxmkpxmfkzyczn:e9Ty!d_W3m-Fu-U@aws-0-eu-central-1.pooler.supabase.com:6543/postgres"

# Create a connection to the PostgreSQL database using psycopg2
conn = psycopg2.connect(postgres_url)

# Create an engine to interact with PostgreSQL using SQLAlchemy
engine = create_engine(postgres_url)


# Step 1: Extract data (example: querying three tables from PostgreSQL)
def extract_data():
    # Example: Fetch data from DimUser table, FactTransaction, and FactVirtualCard
    user_df = pd.read_sql_query("SELECT * FROM DimUser", conn)
    transaction_df = pd.read_sql_query("SELECT * FROM FactTransaction", conn)
    virtual_card_df = pd.read_sql_query("SELECT * FROM FactVirtualCard", conn)
    return user_df, transaction_df, virtual_card_df


# Step 2: Transform data (perform any transformations you need)
def transform_data(user_df, transaction_df, virtual_card_df):
    # Example: Ensure all usernames are lowercase and remove duplicates from transaction data
    user_df['username'] = user_df['username'].str.lower()

    # Remove duplicates from the transaction and virtual card dataframes
    transaction_df = transaction_df.drop_duplicates()
    virtual_card_df = virtual_card_df.drop_duplicates()

    # Return the transformed dataframes
    return user_df, transaction_df, virtual_card_df


# Step 3: Load data into PostgreSQL tables (replace with your warehouse table names)
def load_data(user_df, transaction_df, virtual_card_df):
    # Example: Load transformed data back into PostgreSQL (into "DimUserWarehouse" table, etc.)
    user_df.to_sql('DimUserWarehouse', engine, if_exists='replace', index=False)
    transaction_df.to_sql('FactTransactionWarehouse', engine, if_exists='replace', index=False)
    virtual_card_df.to_sql('FactVirtualCardWarehouse', engine, if_exists='replace', index=False)
    print("Data loaded successfully.")


# Run ETL process
user_df, transaction_df, virtual_card_df = extract_data()
user_df, transaction_df, virtual_card_df = transform_data(user_df, transaction_df, virtual_card_df)

# Display the extracted data to see it
print("User Data:")
print(user_df.head().to_string())  # Show the first 5 rows of user data

print("\nTransaction Data:")
print(transaction_df.head().to_string())  # Show the first 5 rows of transaction data

print("\nVirtual Card Data:")
print(virtual_card_df.head().to_string())  # Show the first 5 rows of virtual card data

load_data(user_df, transaction_df, virtual_card_df)

# Close the PostgreSQL connection
conn.close()
