// Fetch and display dashboard data
async function fetchDashboardData() {
    try {
        const response = await fetch('http://localhost:3000/dashboard');
        const data = await response.json();

        // Set Total Transactions
        document.getElementById('totalTransactions').textContent = data.total_transactions.total_transactions;

        // Set Total Users
        document.getElementById('totalUsers').textContent = data.total_users.total_users;

        // Set Active Users
        document.getElementById('activeUsers').textContent = data.active_users.active_users;

        // Set Total Balance
        document.getElementById('totalBalance').textContent = `$${data.total_balance.total_balance}`;

        // Transaction Summary Chart (Pie Chart)
        const transactionSummaryCtx = document.getElementById('transactionSummaryChart').getContext('2d');
        new Chart(transactionSummaryCtx, {
            type: 'pie',
            data: {
                labels: data.transaction_summary.map(item => item.transaction_type),
                datasets: [{
                    data: data.transaction_summary.map(item => item.total_amount),
                    backgroundColor: ['#ff6384', '#36a2eb', '#cc65fe', '#ffce56']
                }]
            },
            options: { responsive: true }
        });

        // Active vs Non-Active Users Pie Chart
        const activeVsNonActiveCtx = document.getElementById('activeVsNonActiveChart').getContext('2d');
        new Chart(activeVsNonActiveCtx, {
            type: 'pie',
            data: {
                labels: ['Active Users', 'Non-Active Users'],
                datasets: [{
                    data: [data.active_users.active_users, data.total_users.total_users - data.active_users.active_users],
                    backgroundColor: ['#36a2eb', '#ff6384']
                }]
            },
            options: { responsive: true }
        });

        // Monthly Summary Chart (Bar Chart)
        const monthlySummaryCtx = document.getElementById('monthlySummaryChart').getContext('2d');
        new Chart(monthlySummaryCtx, {
            type: 'bar',
            data: {
                labels: data.monthly_summary.map(item => item.month),
                datasets: [{
                    label: 'Amount',
                    data: data.monthly_summary.map(item => item.total_amount),
                    backgroundColor: '#4a90e2'
                }]
            },
            options: {
                scales: {
                    y: { beginAtZero: true }
                },
                responsive: true
            }
        });

        // Line Chart
        const lineChartCtx = document.getElementById('lineChart').getContext('2d');
        new Chart(lineChartCtx, {
            type: 'line',
            data: {
                labels: data.monthly_summary.map(item => item.month),
                datasets: [{
                    label: 'Trend',
                    data: data.monthly_summary.map(item => item.total_amount),
                    borderColor: '#4a90e2',
                    fill: false
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });

        // Radar Chart
        const radarChartCtx = document.getElementById('radarChart').getContext('2d');
        new Chart(radarChartCtx, {
            type: 'radar',
            data: {
                labels: ['January', 'February', 'March', 'April', 'May'],
                datasets: [{
                    label: 'Performance',
                    data: [20, 30, 40, 50, 60],
                    backgroundColor: 'rgba(74, 144, 226, 0.3)',
                    borderColor: '#4a90e2',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true
            }
        });

        // Doughnut Chart
        const doughnutChartCtx = document.getElementById('doughnutChart').getContext('2d');
        new Chart(doughnutChartCtx, {
            type: 'doughnut',
            data: {
                labels: ['Sales', 'Returns', 'Other'],
                datasets: [{
                    data: [60, 25, 15],
                    backgroundColor: ['#36a2eb', '#ff6384', '#ffce56']
                }]
            },
            options: {
                responsive: true
            }
        });

        // Recent Transactions Table
        const recentTransactionsTable = document.getElementById('recentTransactionsTable');
        data.recent_transactions.forEach(transaction => {
            const row = `
                <tr>
                    <td>${transaction.id}</td>
                    <td>${transaction.amount}</td>
                    <td>${transaction.transaction_type}</td>
                    <td>${transaction.date}</td>
                </tr>
            `;
            recentTransactionsTable.innerHTML += row;
        });
    } catch (error) {
        console.error('Error fetching dashboard data:', error);
    }
}

// Fetch data when the page loads
document.addEventListener('DOMContentLoaded', fetchDashboardData);
