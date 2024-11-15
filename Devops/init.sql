-- Initialize the database, roles, and permissions

-- Create the database if it doesn't already exist
CREATE DATABASE mydb;

-- Switch to the database
\c mydb;

-- Create a user for the application with password and privileges
CREATE USER app_user WITH PASSWORD 'secure_password';

-- Grant privileges to the user
GRANT ALL PRIVILEGES ON DATABASE mydb TO app_user;

-- Create the tables required for the application

-- Example 1: Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example 2: Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some initial data (optional)
INSERT INTO users (username, email, password_hash)
VALUES 
    ('testuser1', 'testuser1@example.com', 'hashed_password_1'),
    ('testuser2', 'testuser2@example.com', 'hashed_password_2');

INSERT INTO transactions (user_id, amount, transaction_type, status)
VALUES 
    (1, 100.00, 'deposit', 'completed'),
    (1, 50.00, 'withdrawal', 'completed'),
    (2, 200.00, 'deposit', 'completed');

-- Grant all privileges on the tables to the application user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_user;
