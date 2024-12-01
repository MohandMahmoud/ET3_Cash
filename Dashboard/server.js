const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
require('dotenv').config(); // To load environment variables from .env file

const app = express();
app.use(cors()); // Allow cross-origin requests

// Configure the PostgreSQL connection using environment variables
const pool = new Pool({
    connectionString: "postgresql://postgres.rmywqhaxmkpxmfkzyczn:e9Ty!d_W3m-Fu-U@aws-0-eu-central-1.pooler.supabase.com:6543/postgres"
});

// Consolidated dashboard endpoint
app.get('/dashboard', async (req, res) => {
    try {
        const client = await pool.connect();

        // Queries for all required data
        const queries = {
            transactionSummary: `
                SELECT d.transaction_type, SUM(f.amount) AS total_amount
                FROM facttransaction f
                JOIN dimtransactiontype d ON f.transaction_type_id = d.transaction_type_id
                GROUP BY d.transaction_type
            `,
            totalTransactions: `
                SELECT COUNT(*) AS total_transactions
                FROM "FactTransactionWarehouse"
            `,
            totalUsers: `
                SELECT COUNT(*) AS total_users
                FROM "DimUser"
            `,
            activeUsers: `
                SELECT COUNT(*) AS active_users
                FROM "DimUser"
                WHERE "IsActive" = true
            `,
            inactiveUsers: `
                SELECT COUNT(*) AS inactive_users
                FROM "DimUser"
                WHERE "IsActive" = false
            `,
            totalBalance: `
                SELECT SUM("Balance") AS total_balance
                FROM "DimUser"
            `,
            monthlySummary: `
                SELECT TO_CHAR(f.transaction_date_id, 'YYYY-MM') AS month, SUM(f.amount) AS total_amount
                FROM "FactTransactionWarehouse" f
                GROUP BY TO_CHAR(f.transaction_date_id, 'YYYY-MM')
                ORDER BY month
            `,
            recentTransactions: `
                SELECT f.transaction_id, f.amount, d.transaction_type, f.transaction_date_id
                FROM "FactTransactionWarehouse" f
                JOIN dimtransactiontype d ON f.transaction_type_id = d.transaction_type_id
                ORDER BY f.transaction_date_id DESC
                LIMIT 10
            `
        };

        // Execute all queries concurrently
        const results = await Promise.all([
            client.query(queries.transactionSummary),
            client.query(queries.totalTransactions),
            client.query(queries.totalUsers),
            client.query(queries.activeUsers),
            client.query(queries.inactiveUsers),
            client.query(queries.totalBalance),
            client.query(queries.monthlySummary),
            client.query(queries.recentTransactions)
        ]);

        client.release();

        // Combine results into a single response
        res.json({
            transaction_summary: results[0].rows,
            total_transactions: results[1].rows[0],
            total_users: results[2].rows[0],
            active_users: results[3].rows[0],
            inactive_users: results[4].rows[0],
            total_balance: results[5].rows[0],
            monthly_summary: results[6].rows,
            recent_transactions: results[7].rows
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error fetching dashboard data' });
    }
});

// Start the server
app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});
