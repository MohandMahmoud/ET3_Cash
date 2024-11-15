class User {
  final int customerId;
  final String username;
  final double balance;
  final double savingsBalance;
  final String pin;
  final List<dynamic> transactionHistory;

  User({
    required this.customerId,
    required this.username,
    required this.balance,
    required this.savingsBalance,
    required this.pin,
    required this.transactionHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      customerId: json['customer_id'],
      username: json['username'],
      balance: double.parse(json['balance']),
      savingsBalance: double.parse(json['savings_balance']),
      pin: json['pin'],
      transactionHistory: json['transaction_history'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'username': username,
      'balance': balance,
      'savings_balance': savingsBalance,
      'pin': pin,
      'transaction_history': transactionHistory,
    };
  }
}
