import 'package:flutter/material.dart';
import 'package:new_app/lib/models/transaction_manager.dart'; // Update with your actual import

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final int _itemsPerPage = 10; // Number of transactions per page
  int _currentPage = 0; // Current page index
  List<Transaction> _transactions = []; // List to store transactions
  int _totalPages = 0; // Total number of pages

  @override
  void initState() {
    super.initState();
    _refreshTransactions(); // Load transactions
  }

  void _refreshTransactions() {
    setState(() {
      _transactions = TransactionManager().getTransactions();
      _totalPages = (_transactions.length / _itemsPerPage).ceil(); // Calculate total pages
      _currentPage = 0; // Reset to first page
    });
  }

  // Get transactions for the current page
  List<Transaction> _getCurrentPageTransactions() {
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return _transactions.sublist(
      startIndex,
      endIndex > _transactions.length ? _transactions.length : endIndex,
    );
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _clearHistory() {
    TransactionManager().clearTransactions(); // Clear the transactions in the manager
    _refreshTransactions(); // Refresh the transactions displayed
  }

  @override
  Widget build(BuildContext context) {
    final currentPageTransactions = _getCurrentPageTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY History'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearHistory,
            tooltip: 'Clear History',
          ),
          ClipOval(
            child: Image.asset(
              'assets/images/1724928422745.jpeg',
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentPageTransactions.isEmpty
            ? const Center(
          child: Text(
            'No transactions found.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: currentPageTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = currentPageTransactions[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        transaction.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        transaction.date
                            .toLocal()
                            .toString()
                            .split(' ')[0], // Display only the date
                      ),
                      trailing: Text(
                        '\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction.type == 'Deposit'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text('Previous'),
                ),
                Text(
                  'Page ${_currentPage + 1} of $_totalPages',
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
