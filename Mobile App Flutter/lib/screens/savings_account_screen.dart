import 'package:flutter/material.dart';
import 'package:new_app/lib/models/transaction_manager.dart';

class CreateSavingsAccountScreen extends StatefulWidget {
  const CreateSavingsAccountScreen({super.key});

  @override
  State<CreateSavingsAccountScreen> createState() =>
      _CreateSavingsAccountScreenState();
}

class _CreateSavingsAccountScreenState
    extends State<CreateSavingsAccountScreen> {
  final TextEditingController _initialDepositController =
  TextEditingController();
  final TextEditingController _withdrawAmountController =
  TextEditingController();

  // Instance of the TransactionManager to handle transactions
  final TransactionManager _transactionManager = TransactionManager();

  // Initial balances
  double _balance = 1250.0; // Example main balance
  double _savingsBalance = 4700.0; // Initial savings balance
  final double _maxBalance = 10000.0; // Maximum value for the progress indicator

  void _createSavingsAccount(BuildContext context) {
    String initialDepositText = _initialDepositController.text;

    // Try to parse the initial deposit amount
    double? initialDeposit = double.tryParse(initialDepositText);

    // Validate the inputs
    if (initialDeposit == null || initialDeposit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid initial deposit.')),
      );
      return;
    }

    // Ensure the initial deposit is not more than available balance
    if (initialDeposit > _balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Insufficient balance for initial deposit.')),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Savings Account Creation'),
          content: Text(
              'Are you sure you want to deposit \$${initialDeposit.toStringAsFixed(2)} into your savings account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Adjust the balances
                setState(() {
                  _balance -= initialDeposit; // Decrease main balance
                  _savingsBalance += initialDeposit; // Increase savings balance
                });

                // Log the transaction using the TransactionManager
                _transactionManager.addTransaction(
                  'Deposit to Savings',
                  initialDeposit,
                );

                // Clear the input field
                _initialDepositController.clear();

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Deposited \$${initialDeposit.toStringAsFixed(2)} into savings account.')),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _withdrawFromSavings(BuildContext context) {
    String withdrawAmountText = _withdrawAmountController.text;

    // Try to parse the withdrawal amount
    double? withdrawAmount = double.tryParse(withdrawAmountText);

    // Validate the input
    if (withdrawAmount == null || withdrawAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount to withdraw.')),
      );
      return;
    }

    // Ensure the withdrawal is not more than the savings balance
    if (withdrawAmount > _savingsBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Insufficient savings balance for withdrawal.')),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Withdrawal'),
          content: Text(
              'Are you sure you want to withdraw \$${withdrawAmount.toStringAsFixed(2)} from your savings account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Adjust the balances
                setState(() {
                  _savingsBalance -= withdrawAmount; // Decrease savings balance
                });

                // Log the transaction using the TransactionManager
                _transactionManager.addTransaction(
                  'Withdraw from Savings',
                  withdrawAmount,
                );

                // Clear the input field
                _withdrawAmountController.clear();

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Withdrew \$${withdrawAmount.toStringAsFixed(2)} from savings account.')),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Account'),
        backgroundColor: Colors.blue,
        actions: [
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shadowColor: Colors.blue.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Create a Savings Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _initialDepositController,
                      decoration: InputDecoration(
                        labelText: 'Enter initial deposit:',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _createSavingsAccount(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Savings Account',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Withdrawal section
            Card(
              elevation: 5,
              shadowColor: Colors.red.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Withdraw from Savings Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _withdrawAmountController,
                      decoration: InputDecoration(
                        labelText: 'Enter withdrawal amount:',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _withdrawFromSavings(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Withdraw from Savings',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Circular progress indicator for main balance
            Card(
              elevation: 3,
              shadowColor: Colors.blueGrey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Main Balance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: _balance / _maxBalance,
                            backgroundColor: Colors.grey.shade300,
                            color: Colors.green,
                            strokeWidth: 12,
                          ),
                          Text(
                            '\$${_balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Circular progress indicator for savings balance
            Card(
              elevation: 3,
              shadowColor: Colors.blueGrey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Savings Balance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: _savingsBalance / _maxBalance,
                            backgroundColor: Colors.grey.shade300,
                            color: Colors.blue,
                            strokeWidth: 12,
                          ),
                          Text(
                            '\$${_savingsBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
