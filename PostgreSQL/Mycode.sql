-- Create the CustomUser table
CREATE TABLE CustomUser (
    customer_id SERIAL PRIMARY KEY, 
    username VARCHAR(150) NOT NULL, 
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    email VARCHAR(254),
    password VARCHAR(128),
    is_active BOOLEAN DEFAULT TRUE,
    is_staff BOOLEAN DEFAULT FALSE,
    is_superuser BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP,
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    balance DECIMAL(10, 2) DEFAULT 0.00,
    savings_balance DECIMAL(10, 2) DEFAULT 0.00,
    pin VARCHAR(4),
    transaction_history JSONB DEFAULT '[]'
);

-- Create the Transaction table
CREATE TABLE Transaction (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Send Money', 'Bill Payment', 'Virtual Card', 'Savings Account', 'Withdraw Savings')),
    amount DECIMAL(10, 2) NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    FOREIGN KEY (user_id) REFERENCES CustomUser (customer_id) ON DELETE CASCADE
);

-- Create the VirtualCard table
CREATE TABLE VirtualCard (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    card_name VARCHAR(100) NOT NULL,
    "limit" DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES CustomUser (customer_id) ON DELETE CASCADE
);


-- Add index on customer_id for faster queries in Transaction table
CREATE INDEX idx_transaction_user_id ON Transaction (user_id);

-- Add index on user_id for faster queries in VirtualCard table
CREATE INDEX idx_virtualcard_user_id ON VirtualCard (user_id);

INSERT INTO CustomUser (username, first_name, last_name, email, password, balance, savings_balance, pin, transaction_history)
VALUES
('user101', 'FirstName101', 'LastName101', 'user101@example.com', 'password101', 5000.00, 1000.00, '0000', '[]'),
('user102', 'FirstName102', 'LastName102', 'user102@example.com', 'password102', 5200.00, 1100.00, '1111', '[]'),
('user103', 'FirstName103', 'LastName103', 'user103@example.com', 'password103', 5300.00, 1200.00, '1234', '[]'),
('user104', 'FirstName104', 'LastName104', 'user104@example.com', 'password104', 5400.00, 1300.00, '2222', '[]'),
('user105', 'FirstName105', 'LastName105', 'user105@example.com', 'password105', 5500.00, 1400.00, '1234', '[]'),
('user106', 'FirstName106', 'LastName106', 'user106@example.com', 'password106', 5600.00, 1500.00, '1234', '[]'),
('user107', 'FirstName107', 'LastName107', 'user107@example.com', 'password107', 5700.00, 1600.00, '1234', '[]'),
('user108', 'FirstName108', 'LastName108', 'user108@example.com', 'password108', 5800.00, 1700.00, '1234', '[]'),
('user109', 'FirstName109', 'LastName109', 'user109@example.com', 'password109', 5900.00, 1800.00, '1234', '[]'),
('user110', 'FirstName110', 'LastName110', 'user110@example.com', 'password110', 6000.00, 1900.00, '1234', '[]'),
('user111', 'FirstName111', 'LastName111', 'user111@example.com', 'password111', 6100.00, 2000.00, '1234', '[]'),
('user112', 'FirstName112', 'LastName112', 'user112@example.com', 'password112', 6200.00, 2100.00, '1234', '[]'),
('user113', 'FirstName113', 'LastName113', 'user113@example.com', 'password113', 6300.00, 2200.00, '1234', '[]'),
('user114', 'FirstName114', 'LastName114', 'user114@example.com', 'password114', 6400.00, 2300.00, '1234', '[]'),
('user115', 'FirstName115', 'LastName115', 'user115@example.com', 'password115', 6500.00, 2400.00, '1234', '[]'),
('user116', 'FirstName116', 'LastName116', 'user116@example.com', 'password116', 6600.00, 2500.00, '1234', '[]'),
('user117', 'FirstName117', 'LastName117', 'user117@example.com', 'password117', 6700.00, 2600.00, '1234', '[]'),
('user118', 'FirstName118', 'LastName118', 'user118@example.com', 'password118', 6800.00, 2700.00, '1234', '[]'),
('user119', 'FirstName119', 'LastName119', 'user119@example.com', 'password119', 6900.00, 2800.00, '1234', '[]'),
('user120', 'FirstName120', 'LastName120', 'user120@example.com', 'password120', 7000.00, 2900.00, '1234', '[]');
UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1000.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 500.00, "date": "2024-11-02"}]'
WHERE username = 'user101';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1200.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 600.00, "date": "2024-11-02"}]'
WHERE username = 'user102';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1300.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 700.00, "date": "2024-11-02"}]'
WHERE username = 'user103';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1400.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 800.00, "date": "2024-11-02"}]'
WHERE username = 'user104';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1500.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 900.00, "date": "2024-11-02"}]'
WHERE username = 'user105';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1600.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1000.00, "date": "2024-11-02"}]'
WHERE username = 'user106';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1700.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1100.00, "date": "2024-11-02"}]'
WHERE username = 'user107';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1800.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1200.00, "date": "2024-11-02"}]'
WHERE username = 'user108';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 1900.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1300.00, "date": "2024-11-02"}]'
WHERE username = 'user109';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2000.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1400.00, "date": "2024-11-02"}]'
WHERE username = 'user110';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2100.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1500.00, "date": "2024-11-02"}]'
WHERE username = 'user111';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2200.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1600.00, "date": "2024-11-02"}]'
WHERE username = 'user112';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2300.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1700.00, "date": "2024-11-02"}]'
WHERE username = 'user113';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2400.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1800.00, "date": "2024-11-02"}]'
WHERE username = 'user114';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2500.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 1900.00, "date": "2024-11-02"}]'
WHERE username = 'user115';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2600.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 2000.00, "date": "2024-11-02"}]'
WHERE username = 'user116';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2700.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 2100.00, "date": "2024-11-02"}]'
WHERE username = 'user117';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2800.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 2200.00, "date": "2024-11-02"}]'
WHERE username = 'user118';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 2900.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 2300.00, "date": "2024-11-02"}]'
WHERE username = 'user119';

UPDATE CustomUser
SET transaction_history = '[{"transaction_type": "deposit", "amount": 3000.00, "date": "2024-11-01"}, {"transaction_type": "withdrawal", "amount": 2400.00, "date": "2024-11-02"}]'
WHERE username = 'user120';

INSERT INTO Transaction (user_id, transaction_type, amount, details)
VALUES
(1, 'Deposit', 1000.00, 'Deposit of 1000'),
(1, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(1, 'Send Money', 200.00, 'Sent 200 to user2'),
(1, 'Bill Payment', 150.00, 'Paid electricity bill of 150'),
(1, 'Virtual Card', 1000.00, 'Created virtual card with 1000 balance'),
(1, 'Savings Account', 500.00, 'Deposited 500 to savings account'),
(1, 'Withdraw Savings', 200.00, 'Withdrew 200 from savings account'),
(1, 'Deposit', 1500.00, 'Deposit of 1500'),
(1, 'Withdrawal', 300.00, 'Withdrawal of 300'),
(1, 'Send Money', 500.00, 'Sent 500 to user3'),
(2, 'Deposit', 1000.00, 'Deposit of 1000'),
(2, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(2, 'Send Money', 100.00, 'Sent 100 to user4'),
(2, 'Bill Payment', 200.00, 'Paid internet bill of 200'),
(2, 'Virtual Card', 1200.00, 'Created virtual card with 1200 balance'),
(2, 'Savings Account', 700.00, 'Deposited 700 to savings account'),
(2, 'Withdraw Savings', 250.00, 'Withdrew 250 from savings account'),
(2, 'Deposit', 2000.00, 'Deposit of 2000'),
(2, 'Withdrawal', 350.00, 'Withdrawal of 350'),
(2, 'Send Money', 300.00, 'Sent 300 to user5'),
(3, 'Deposit', 1000.00, 'Deposit of 1000'),
(3, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(3, 'Send Money', 100.00, 'Sent 100 to user6'),
(3, 'Bill Payment', 250.00, 'Paid water bill of 250'),
(3, 'Virtual Card', 1500.00, 'Created virtual card with 1500 balance'),
(3, 'Savings Account', 800.00, 'Deposited 800 to savings account'),
(3, 'Withdraw Savings', 300.00, 'Withdrew 300 from savings account'),
(3, 'Deposit', 1500.00, 'Deposit of 1500'),
(3, 'Withdrawal', 200.00, 'Withdrawal of 200'),
(3, 'Send Money', 600.00, 'Sent 600 to user7'),
(4, 'Deposit', 1000.00, 'Deposit of 1000'),
(4, 'Withdrawal', 250.00, 'Withdrawal of 250'),
(4, 'Send Money', 150.00, 'Sent 150 to user8'),
(4, 'Bill Payment', 100.00, 'Paid gas bill of 100'),
(4, 'Virtual Card', 900.00, 'Created virtual card with 900 balance'),
(4, 'Savings Account', 600.00, 'Deposited 600 to savings account'),
(4, 'Withdraw Savings', 150.00, 'Withdrew 150 from savings account'),
(4, 'Deposit', 2500.00, 'Deposit of 2500'),
(4, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(4, 'Send Money', 200.00, 'Sent 200 to user9'),
(5, 'Deposit', 1000.00, 'Deposit of 1000'),
(5, 'Withdrawal', 300.00, 'Withdrawal of 300'),
(5, 'Send Money', 500.00, 'Sent 500 to user10'),
(5, 'Bill Payment', 150.00, 'Paid mobile bill of 150'),
(5, 'Virtual Card', 1200.00, 'Created virtual card with 1200 balance'),
(5, 'Savings Account', 400.00, 'Deposited 400 to savings account'),
(5, 'Withdraw Savings', 100.00, 'Withdrew 100 from savings account'),
(5, 'Deposit', 2000.00, 'Deposit of 2000'),
(5, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(5, 'Send Money', 400.00, 'Sent 400 to user11'),
(6, 'Deposit', 1000.00, 'Deposit of 1000'),
(6, 'Withdrawal', 350.00, 'Withdrawal of 350'),
(6, 'Send Money', 150.00, 'Sent 150 to user12'),
(6, 'Bill Payment', 250.00, 'Paid broadband bill of 250'),
(6, 'Virtual Card', 1300.00, 'Created virtual card with 1300 balance'),
(6, 'Savings Account', 900.00, 'Deposited 900 to savings account'),
(6, 'Withdraw Savings', 300.00, 'Withdrew 300 from savings account'),
(6, 'Deposit', 2500.00, 'Deposit of 2500'),
(6, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(6, 'Send Money', 200.00, 'Sent 200 to user13'),
(7, 'Deposit', 1000.00, 'Deposit of 1000'),
(7, 'Withdrawal', 250.00, 'Withdrawal of 250'),
(7, 'Send Money', 300.00, 'Sent 300 to user14'),
(7, 'Bill Payment', 150.00, 'Paid electricity bill of 150'),
(7, 'Virtual Card', 1100.00, 'Created virtual card with 1100 balance'),
(7, 'Savings Account', 800.00, 'Deposited 800 to savings account'),
(7, 'Withdraw Savings', 150.00, 'Withdrew 150 from savings account'),
(7, 'Deposit', 3000.00, 'Deposit of 3000'),
(7, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(7, 'Send Money', 500.00, 'Sent 500 to user15'),
(8, 'Deposit', 1000.00, 'Deposit of 1000'),
(8, 'Withdrawal', 150.00, 'Withdrawal of 150'),
(8, 'Send Money', 250.00, 'Sent 250 to user16'),
(8, 'Bill Payment', 200.00, 'Paid internet bill of 200'),
(8, 'Virtual Card', 1400.00, 'Created virtual card with 1400 balance'),
(8, 'Savings Account', 600.00, 'Deposited 600 to savings account'),
(8, 'Withdraw Savings', 200.00, 'Withdrew 200 from savings account'),
(8, 'Deposit', 2000.00, 'Deposit of 2000'),
(8, 'Withdrawal', 350.00, 'Withdrawal of 350'),
(8, 'Send Money', 100.00, 'Sent 100 to user17'),
(9, 'Deposit', 1000.00, 'Deposit of 1000'),
(9, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(9, 'Send Money', 400.00, 'Sent 400 to user18'),
(9, 'Bill Payment', 250.00, 'Paid gas bill of 250'),
(9, 'Virtual Card', 1300.00, 'Created virtual card with 1300 balance'),
(9, 'Savings Account', 900.00, 'Deposited 900 to savings account'),
(9, 'Withdraw Savings', 350.00, 'Withdrew 350 from savings account'),
(9, 'Deposit', 2500.00, 'Deposit of 2500'),
(9, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(9, 'Send Money', 200.00, 'Sent 200 to user19'),
(10, 'Deposit', 1000.00, 'Deposit of 1000'),
(10, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(10, 'Send Money', 200.00, 'Sent 200 to user20'),
(10, 'Bill Payment', 150.00, 'Paid mobile bill of 150'),
(10, 'Virtual Card', 1100.00, 'Created virtual card with 1100 balance'),
(10, 'Savings Account', 1000.00, 'Deposited 1000 to savings account'),
(10, 'Withdraw Savings', 200.00, 'Withdrew 200 from savings account');

INSERT INTO VirtualCard (user_id, card_name, "limit", created_at)
VALUES
(1, 'Virtual Card 101', 1000.00, CURRENT_TIMESTAMP),
(2, 'Virtual Card 102', 2000.00, CURRENT_TIMESTAMP),
(3, 'Virtual Card 103', 1500.00, CURRENT_TIMESTAMP),
(4, 'Virtual Card 104', 2500.00, CURRENT_TIMESTAMP),
(5, 'Virtual Card 105', 3000.00, CURRENT_TIMESTAMP),
(6, 'Virtual Card 106', 1800.00, CURRENT_TIMESTAMP),
(7, 'Virtual Card 107', 2200.00, CURRENT_TIMESTAMP),
(8, 'Virtual Card 108', 2700.00, CURRENT_TIMESTAMP),
(9, 'Virtual Card 109', 3200.00, CURRENT_TIMESTAMP),
(10, 'Virtual Card 110', 3500.00, CURRENT_TIMESTAMP),
(11, 'Virtual Card 111', 1000.00, CURRENT_TIMESTAMP),
(12, 'Virtual Card 112', 2000.00, CURRENT_TIMESTAMP),
(13, 'Virtual Card 113', 1500.00, CURRENT_TIMESTAMP),
(14, 'Virtual Card 114', 2500.00, CURRENT_TIMESTAMP),
(15, 'Virtual Card 115', 3000.00, CURRENT_TIMESTAMP),
(16, 'Virtual Card 116', 1800.00, CURRENT_TIMESTAMP),
(17, 'Virtual Card 117', 2200.00, CURRENT_TIMESTAMP),
(18, 'Virtual Card 118', 2700.00, CURRENT_TIMESTAMP),
(19, 'Virtual Card 119', 3200.00, CURRENT_TIMESTAMP),
(20, 'Virtual Card 120', 3500.00, CURRENT_TIMESTAMP);


INSERT INTO Transaction (user_id, transaction_type, amount, details)
VALUES
(1, 'Deposit', 1000.00, 'Deposit of 1000'),
(1, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(1, 'Send Money', 200.00, 'Sent 200 to user2'),
(1, 'Bill Payment', 150.00, 'Paid electricity bill of 150'),
(1, 'Virtual Card', 1000.00, 'Created virtual card with 1000 balance'),
(1, 'Savings Account', 500.00, 'Deposited 500 to savings account'),
(1, 'Withdraw Savings', 200.00, 'Withdrew 200 from savings account'),
(1, 'Deposit', 1500.00, 'Deposit of 1500'),
(1, 'Withdrawal', 300.00, 'Withdrawal of 300'),
(1, 'Send Money', 500.00, 'Sent 500 to user3'),
(2, 'Deposit', 1000.00, 'Deposit of 1000'),
(2, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(2, 'Send Money', 100.00, 'Sent 100 to user4'),
(2, 'Bill Payment', 200.00, 'Paid internet bill of 200'),
(2, 'Virtual Card', 1200.00, 'Created virtual card with 1200 balance'),
(2, 'Savings Account', 700.00, 'Deposited 700 to savings account'),
(2, 'Withdraw Savings', 250.00, 'Withdrew 250 from savings account'),
(2, 'Deposit', 2000.00, 'Deposit of 2000'),
(2, 'Withdrawal', 350.00, 'Withdrawal of 350'),
(2, 'Send Money', 300.00, 'Sent 300 to user5'),
(3, 'Deposit', 1000.00, 'Deposit of 1000'),
(3, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(3, 'Send Money', 100.00, 'Sent 100 to user6'),
(3, 'Bill Payment', 250.00, 'Paid water bill of 250'),
(3, 'Virtual Card', 1500.00, 'Created virtual card with 1500 balance'),
(3, 'Savings Account', 800.00, 'Deposited 800 to savings account'),
(3, 'Withdraw Savings', 300.00, 'Withdrew 300 from savings account'),
(3, 'Deposit', 1500.00, 'Deposit of 1500'),
(3, 'Withdrawal', 200.00, 'Withdrawal of 200'),
(3, 'Send Money', 600.00, 'Sent 600 to user7'),
(4, 'Deposit', 1000.00, 'Deposit of 1000'),
(4, 'Withdrawal', 250.00, 'Withdrawal of 250'),
(4, 'Send Money', 150.00, 'Sent 150 to user8'),
(4, 'Bill Payment', 100.00, 'Paid gas bill of 100'),
(4, 'Virtual Card', 900.00, 'Created virtual card with 900 balance'),
(4, 'Savings Account', 600.00, 'Deposited 600 to savings account'),
(4, 'Withdraw Savings', 150.00, 'Withdrew 150 from savings account'),
(4, 'Deposit', 2500.00, 'Deposit of 2500'),
(4, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(4, 'Send Money', 200.00, 'Sent 200 to user9'),
(5, 'Deposit', 1000.00, 'Deposit of 1000'),
(5, 'Withdrawal', 300.00, 'Withdrawal of 300'),
(5, 'Send Money', 500.00, 'Sent 500 to user10'),
(5, 'Bill Payment', 150.00, 'Paid mobile bill of 150'),
(5, 'Virtual Card', 1200.00, 'Created virtual card with 1200 balance'),
(5, 'Savings Account', 400.00, 'Deposited 400 to savings account'),
(5, 'Withdraw Savings', 100.00, 'Withdrew 100 from savings account'),
(5, 'Deposit', 2000.00, 'Deposit of 2000'),
(5, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(5, 'Send Money', 400.00, 'Sent 400 to user11'),
(6, 'Deposit', 1000.00, 'Deposit of 1000'),
(6, 'Withdrawal', 350.00, 'Withdrawal of 350'),
(6, 'Send Money', 150.00, 'Sent 150 to user12'),
(6, 'Bill Payment', 250.00, 'Paid broadband bill of 250'),
(6, 'Virtual Card', 1300.00, 'Created virtual card with 1300 balance'),
(6, 'Savings Account', 900.00, 'Deposited 900 to savings account'),
(6, 'Withdraw Savings', 300.00, 'Withdrew 300 from savings account'),
(6, 'Deposit', 2500.00, 'Deposit of 2500'),
(6, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(6, 'Send Money', 200.00, 'Sent 200 to user13'),
(7, 'Deposit', 1000.00, 'Deposit of 1000'),
(7, 'Withdrawal', 250.00, 'Withdrawal of 250'),
(7, 'Send Money', 300.00, 'Sent 300 to user14'),
(7, 'Bill Payment', 150.00, 'Paid electricity bill of 150'),
(7, 'Virtual Card', 1100.00, 'Created virtual card with 1100 balance'),
(7, 'Savings Account', 800.00, 'Deposited 800 to savings account'),
(7, 'Withdraw Savings', 150.00, 'Withdrew 150 from savings account'),
(7, 'Deposit', 3000.00, 'Deposit of 3000'),
(7, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(7, 'Send Money', 500.00, 'Sent 500 to user15'),
(8, 'Deposit', 1000.00, 'Deposit of 1000'),
(8, 'Withdrawal', 150.00, 'Withdrawal of 150'),
(8, 'Send Money', 250.00, 'Sent 250 to user16'),
(8, 'Bill Payment', 200.00, 'Paid internet bill of 200'),
(8, 'Virtual Card', 1400.00, 'Created virtual card with 1400 balance'),
(8, 'Savings Account', 600.00, 'Deposited 600 to savings account'),
(8, 'Withdraw Savings', 200.00, 'Withdrew 200 from savings account'),
(8, 'Deposit', 2000.00, 'Deposit of 2000'),
(8, 'Withdrawal', 350.00, 'Withdrawal of 350'),
(8, 'Send Money', 100.00, 'Sent 100 to user17'),
(9, 'Deposit', 1000.00, 'Deposit of 1000'),
(9, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(9, 'Send Money', 400.00, 'Sent 400 to user18'),
(9, 'Bill Payment', 250.00, 'Paid gas bill of 250'),
(9, 'Virtual Card', 1300.00, 'Created virtual card with 1300 balance'),
(9, 'Savings Account', 900.00, 'Deposited 900 to savings account'),
(9, 'Withdraw Savings', 350.00, 'Withdrew 350 from savings account'),
(9, 'Deposit', 2500.00, 'Deposit of 2500'),
(9, 'Withdrawal', 400.00, 'Withdrawal of 400'),
(9, 'Send Money', 200.00, 'Sent 200 to user19'),
(10, 'Deposit', 1000.00, 'Deposit of 1000'),
(10, 'Withdrawal', 500.00, 'Withdrawal of 500'),
(10, 'Send Money', 200.00, 'Sent 200 to user20'),
(10, 'Bill Payment', 150.00, 'Paid mobile bill of 150'),
(10, 'Virtual Card', 1100.00, 'Created virtual card with 1100 balance'),
(10, 'Savings Account', 1000.00, 'Deposited 1000 to savings account'),
(10, 'Withdraw Savings', 200.00, 'Withdrew 200 from savings account');

--This procedure will allow inserting new users into the CustomUser table. It will take the necessary user information as input and insert it.
CREATE OR REPLACE PROCEDURE insert_custom_user(
    p_username VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_email VARCHAR,
    p_password VARCHAR,
    p_balance DECIMAL(10, 2),
    p_savings_balance DECIMAL(10, 2),
    p_pin VARCHAR,
    p_transaction_history TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO CustomUser (username, first_name, last_name, email, password, balance, savings_balance, pin, transaction_history)
    VALUES (p_username, p_first_name, p_last_name, p_email, p_password, p_balance, p_savings_balance, p_pin, p_transaction_history);
END;
$$;

--This procedure will insert transaction records into the Transaction table, considering different transaction types like Deposit, Withdrawal, Send Money, etc.
CREATE OR REPLACE PROCEDURE insert_transaction(
    p_user_id INTEGER,
    p_transaction_type VARCHAR,
    p_amount DECIMAL(10, 2),
    p_details VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Transaction (user_id, transaction_type, amount, details)
    VALUES (p_user_id, p_transaction_type, p_amount, p_details);
END;
$$;

--This procedure will insert records into the VirtualCard table for a given user_id, card name, limit, and created timestamp.
CREATE OR REPLACE PROCEDURE insert_virtual_card(
    p_user_id INTEGER,
    p_card_name VARCHAR,
    p_limit DECIMAL(10, 2),
    p_created_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO VirtualCard (user_id, card_name, "limit", created_at)
    VALUES (p_user_id, p_card_name, p_limit, p_created_at);
END;
$$;

--This procedure will handle withdrawals from a user's savings account. It will check if the user has sufficient savings before proceeding with the withdrawal.
CREATE OR REPLACE PROCEDURE withdraw_savings(
    p_user_id INTEGER,
    p_amount DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_savings DECIMAL(10, 2);
BEGIN
    -- Get the current savings balance
    SELECT savings_balance INTO current_savings
    FROM CustomUser
    WHERE id = p_user_id;

    -- Check if the user has enough savings
    IF current_savings >= p_amount THEN
        -- Deduct the amount from savings balance
        UPDATE CustomUser
        SET savings_balance = savings_balance - p_amount
        WHERE id = p_user_id;

        -- Log the transaction
        PERFORM insert_transaction(p_user_id, 'Withdraw Savings', p_amount, 'Withdrawal from savings');
    ELSE
        RAISE EXCEPTION 'Insufficient savings balance for user_id: %', p_user_id;
    END IF;
END;
$$;

--This procedure will deposit a certain amount into the user's balance.
CREATE OR REPLACE PROCEDURE deposit_funds(
    p_user_id INTEGER,
    p_amount DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update the user's balance with the deposit amount
    UPDATE CustomUser
    SET balance = balance + p_amount
    WHERE id = p_user_id;

    -- Log the transaction
    PERFORM insert_transaction(p_user_id, 'Deposit', p_amount, 'Deposit funds');
END;
$$;
--This procedure will withdraw a certain amount from the user's main balance.
CREATE OR REPLACE PROCEDURE withdraw_funds(
    p_user_id INTEGER,
    p_amount DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance DECIMAL(10, 2);
BEGIN
    -- Get the current balance of the user
    SELECT balance INTO current_balance
    FROM CustomUser
    WHERE id = p_user_id;

    -- Check if the user has enough balance
    IF current_balance >= p_amount THEN
        -- Deduct the amount from the balance
        UPDATE CustomUser
        SET balance = balance - p_amount
        WHERE id = p_user_id;

        -- Log the transaction
        PERFORM insert_transaction(p_user_id, 'Withdrawal', p_amount, 'Withdraw funds');
    ELSE
        RAISE EXCEPTION 'Insufficient balance for user_id: %', p_user_id;
    END IF;
END;
$$;
--This procedure will transfer a certain amount of money from one user to another.
CREATE OR REPLACE PROCEDURE send_money(
    p_from_user_id INTEGER,
    p_to_user_id INTEGER,
    p_amount DECIMAL(10, 2),
    p_details VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance DECIMAL(10, 2);
BEGIN
    -- Get the current balance of the sender
    SELECT balance INTO current_balance
    FROM CustomUser
    WHERE id = p_from_user_id;

    -- Check if the sender has enough balance
    IF current_balance >= p_amount THEN
        -- Deduct the amount from the sender
        UPDATE CustomUser
        SET balance = balance - p_amount
        WHERE id = p_from_user_id;

        -- Add the amount to the recipient
        UPDATE CustomUser
        SET balance = balance + p_amount
        WHERE id = p_to_user_id;

        -- Log the transaction for both users
        PERFORM insert_transaction(p_from_user_id, 'Send Money', p_amount, p_details || ' to user ' || p_to_user_id);
        PERFORM insert_transaction(p_to_user_id, 'Receive Money', p_amount, p_details || ' from user ' || p_from_user_id);
    ELSE
        RAISE EXCEPTION 'Insufficient balance for user_id: %', p_from_user_id;
    END IF;
END;
$$;
--This procedure will allow a user to pay a bill.
CREATE OR REPLACE PROCEDURE pay_bill(
    p_user_id INTEGER,
    p_amount DECIMAL(10, 2),
    p_bill_details VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance DECIMAL(10, 2);
BEGIN
    -- Get the current balance of the user
    SELECT balance INTO current_balance
    FROM CustomUser
    WHERE id = p_user_id;

    -- Check if the user has enough balance
    IF current_balance >= p_amount THEN
        -- Deduct the amount from the balance
        UPDATE CustomUser
        SET balance = balance - p_amount
        WHERE id = p_user_id;

        -- Log the transaction
        PERFORM insert_transaction(p_user_id, 'Bill Payment', p_amount, p_bill_details);
    ELSE
        RAISE EXCEPTION 'Insufficient balance for user_id: %', p_user_id;
    END IF;
END;
$$;




