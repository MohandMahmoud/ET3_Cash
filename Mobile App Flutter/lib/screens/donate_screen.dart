import 'package:flutter/material.dart';
import 'package:new_app/lib/models/transaction_manager.dart'; // Import your transaction manager

class DonateMoneyScreen extends StatefulWidget {
  const DonateMoneyScreen({super.key});

  @override
  _DonateMoneyScreenState createState() => _DonateMoneyScreenState();
}

class _DonateMoneyScreenState extends State<DonateMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _balance = 1150.0; // Initial balance
  final double _maxBalance = 10000.0; // Maximum balance for progress bar
  String? _selectedCharity; // Variable to hold the selected charity

  // List of charities
  final List<String> charities = [
    "57357",
    "Magd Yacoub",
    "Orman",
    "Masr Elkhair"
  ];

  // Instantiate your transaction manager
  final TransactionManager _transactionManager = TransactionManager(); // Assuming you have this class

  void _confirmDonation(BuildContext context) {
    String inputAmount = _amountController.text;
    double? amount = double.tryParse(inputAmount);

    if (amount != null && amount > 0 && _selectedCharity != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Donation'),
            content: Text('Are you sure you want to donate \$${amount.toStringAsFixed(2)} to $_selectedCharity?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _balance += amount; // Update the balance
                    _transactionManager.addTransaction('Donated \$${amount.toStringAsFixed(2)} to $_selectedCharity', amount); // Log the transaction
                    _amountController.clear();

                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Donated: \$${amount.toStringAsFixed(2)} to $_selectedCharity')),
                  );
                  Navigator.of(context).pop();
                  _selectedCharity = null; // Reset charity selection
                },

                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount and select a charity.')),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
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
                      "Donate Funds",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      hint: const Text('Select a charity'),
                      value: _selectedCharity,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCharity = newValue; // Update selected charity
                        });
                      },
                      items: charities.map<DropdownMenuItem<String>>((String charity) {
                        return DropdownMenuItem<String>(
                          value: charity,
                          child: Text(charity),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Enter Amount',
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
                      onPressed: () => _confirmDonation(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Donate',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Progress bar for balance
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
                      "Current Balance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _balance / _maxBalance,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        Text(
                          '\$${_balance.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
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
