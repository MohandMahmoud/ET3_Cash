CREATE TABLE DimUser (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(150) NOT NULL,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    email VARCHAR(254),
    is_active BOOLEAN DEFAULT TRUE,
    is_staff BOOLEAN DEFAULT FALSE,
    is_superuser BOOLEAN DEFAULT FALSE,
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DimTransactionType (
    transaction_type_id SERIAL PRIMARY KEY,
    transaction_type VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE DimDate (
    date_id SERIAL PRIMARY KEY,
    full_date DATE NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    day INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    week INTEGER NOT NULL,
    day_of_week VARCHAR(10)
);

-- Create FactTransaction table with the correct primary key and partitioning column
CREATE TABLE FactTransaction (
    transaction_id SERIAL,
    user_id INTEGER NOT NULL,
    transaction_type_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date_id INTEGER NOT NULL,
    details TEXT,
    PRIMARY KEY (transaction_id, transaction_date_id), -- Include transaction_date_id in primary key
    FOREIGN KEY (user_id) REFERENCES DimUser (user_id),
    FOREIGN KEY (transaction_type_id) REFERENCES DimTransactionType (transaction_type_id),
    FOREIGN KEY (transaction_date_id) REFERENCES DimDate (date_id)
) PARTITION BY RANGE (transaction_date_id);

-- Step 1: Insert data into DimDate (if not already done)
DO $$ 
DECLARE
    start_date DATE := CURRENT_DATE;
BEGIN
    FOR i IN 0..49 LOOP
        INSERT INTO DimDate (full_date, year, month, day, quarter, week, day_of_week)
        VALUES (
            start_date + i,
            EXTRACT(YEAR FROM start_date + i),
            EXTRACT(MONTH FROM start_date + i),
            EXTRACT(DAY FROM start_date + i),
            EXTRACT(QUARTER FROM start_date + i),
            EXTRACT(WEEK FROM start_date + i),
            TO_CHAR(start_date + i, 'Day')
        );
    END LOOP;
END $$;

-- Step 2: Create partitions by referencing date_id (from DimDate)
CREATE TABLE FactTransaction_2023 PARTITION OF FactTransaction FOR VALUES FROM (1) TO (366);  -- Example for the 2023 range

CREATE TABLE FactTransaction_2024 PARTITION OF FactTransaction FOR VALUES FROM (367) TO (732); -- Example for the 2024 range

-- Step 3: Create indexes
CREATE INDEX idx_fact_transaction_user_id ON FactTransaction (user_id);
CREATE INDEX idx_fact_transaction_transaction_type_id ON FactTransaction (transaction_type_id);
CREATE INDEX idx_fact_transaction_transaction_date_id ON FactTransaction (transaction_date_id);

-- Step 4: Create indexes on individual partitions if necessary
CREATE INDEX idx_fact_transaction_user_id_2023 ON FactTransaction_2023 (user_id);
CREATE INDEX idx_fact_transaction_user_id_2024 ON FactTransaction_2024 (user_id);

CREATE TABLE FactVirtualCard (
    card_transaction_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    card_name VARCHAR(100),
    "limit" DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES DimUser (user_id)
);

DO $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO DimUser (username, first_name, last_name, email, is_active, is_staff, is_superuser)
        VALUES (
            'user' || i,
            'FirstName' || i,
            'LastName' || i,
            'user' || i || '@example.com',
            TRUE,
            FALSE,
            FALSE
        );
    END LOOP;
END $$;

DO $$
DECLARE
    transaction_types TEXT[] := ARRAY['Deposit', 'Withdrawal', 'Send Money', 'Bill Payment', 'Virtual Card', 'Savings Account', 'Withdraw Savings', 'Transfer', 'Purchase', 'Refund'];
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO DimTransactionType (transaction_type)
        VALUES (transaction_types[i]);
    END LOOP;
END $$;

DO $$
DECLARE
    start_date DATE := CURRENT_DATE;
BEGIN
    FOR i IN 0..49 LOOP
        INSERT INTO DimDate (full_date, year, month, day, quarter, week, day_of_week)
        VALUES (
            start_date + i,
            EXTRACT(YEAR FROM start_date + i),
            EXTRACT(MONTH FROM start_date + i),
            EXTRACT(DAY FROM start_date + i),
            EXTRACT(QUARTER FROM start_date + i),
            EXTRACT(WEEK FROM start_date + i),
            TO_CHAR(start_date + i, 'Day')
        );
    END LOOP;
END $$;

DO $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO FactTransaction (user_id, transaction_type_id, amount, transaction_date_id, details)
        VALUES (
            (SELECT user_id FROM DimUser ORDER BY RANDOM() LIMIT 1),  -- Random user
            (SELECT transaction_type_id FROM DimTransactionType ORDER BY RANDOM() LIMIT 1),  -- Random transaction type
            ROUND((RANDOM() * 500)::NUMERIC, 2),  -- Random amount up to 500
            (SELECT date_id FROM DimDate ORDER BY RANDOM() LIMIT 1),  -- Random date
            'Sample transaction details for transaction ' || i
        );
    END LOOP;
END $$;

DO $$
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO FactVirtualCard (user_id, card_name, "limit", created_at)
        VALUES (
            (SELECT user_id FROM DimUser ORDER BY RANDOM() LIMIT 1),  -- Random user
            'VirtualCard_' || i,
            ROUND((RANDOM() * 1000)::NUMERIC, 2),  -- Random limit up to 1000
            NOW() - (INTERVAL '1 day' * (FLOOR(RANDOM() * 365)))  -- Random creation date within the past year
        );
    END LOOP;
END $$;

SELECT 
    u.user_id, 
    u.username, 
    u.email, 
    t.amount AS transaction_amount, 
    d.full_date AS transaction_date
FROM 
    DimUser u
JOIN 
    FactTransaction t ON u.user_id = t.user_id
JOIN 
    DimDate d ON t.transaction_date_id = d.date_id
WHERE 
    u.is_active = TRUE AND t.amount > 20.00;
-- Create a materialized view to aggregate transaction data by user and transaction type
CREATE MATERIALIZED VIEW mv_user_transaction_summary AS
SELECT 
    u.user_id,
    u.username,
    tt.transaction_type,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_amount
FROM 
    DimUser u
JOIN 
    FactTransaction t ON u.user_id = t.user_id
JOIN 
    DimTransactionType tt ON t.transaction_type_id = tt.transaction_type_id
GROUP BY 
    u.user_id, u.username, tt.transaction_type;

-- Refresh the materialized view periodically (e.g., once a day)
REFRESH MATERIALIZED VIEW mv_user_transaction_summary;

SELECT * FROM mv_user_transaction_summary;

CREATE INDEX idx_mv_user_transaction_summary ON mv_user_transaction_summary (user_id, transaction_type);