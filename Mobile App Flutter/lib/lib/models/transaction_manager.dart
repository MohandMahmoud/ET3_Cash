// TODO Implement this library.
// lib/models/transaction_manager.dart

class Transaction {
  final String type; // e.g., Deposit, Withdraw, Send Money
  final double amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    required this.date,
  });
}

class TransactionManager {
  // Singleton pattern to ensure only one instance
  static final TransactionManager _instance = TransactionManager._internal();

  // Private constructor
  TransactionManager._internal();

  factory TransactionManager() => _instance;

  final List<Transaction> _transactions = [];

  // Add a new transaction
  void addTransaction(String type, double amount) {
    _transactions.add(Transaction(type: type, amount: amount, date: DateTime.now()));
  }

  // Get all transactions
  List<Transaction> getTransactions() {
    return List.unmodifiable(_transactions);
  }

  // Clear all transactions
  void clearTransactions() {
    _transactions.clear();
  }

  // Calculate total balance based on transactions
  double getTotalBalance() {
    return _transactions.fold(0.0, (sum, transaction) {
      return sum + (transaction.type == 'Deposit' ? transaction.amount : -transaction.amount);
    });
  }
}
