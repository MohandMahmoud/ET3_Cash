class Transaction {
  final int id; // Assuming there is an ID for the transaction
  final String transactionType;
  final double amount;
  final String details;
  final DateTime date;

  Transaction({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.details,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      transactionType: json['transaction_type'],
      amount: double.parse(json['amount']),
      details: json['details'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_type': transactionType,
      'amount': amount,
      'details': details,
      'date': date.toIso8601String(),
    };
  }
}
