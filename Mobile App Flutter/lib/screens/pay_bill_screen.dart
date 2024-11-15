import 'package:flutter/material.dart';
import 'package:new_app/lib/models/transaction_manager.dart';

class PayBillScreen extends StatefulWidget {
  const PayBillScreen({super.key});

  @override
  State<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  final TextEditingController _billNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _balance = 1250.0; // Initial balance
  final double _maxBalance = 10000.0; // Set a maximum balance for the progress bar
  final List<String> _billers = ["Gas", "Water", "Electric", "Internet"];
  String? _selectedBiller; // Store selected biller

  final TransactionManager _transactionManager = TransactionManager(); // Instance of TransactionManager

  void _payBill(BuildContext context) {
    String billNumber = _billNumberController.text;
    String amountText = _amountController.text;

    // Try to parse the amount to a double
    double? amount = double.tryParse(amountText);

    // Validate the amount and inputs
    if (billNumber.isEmpty || amount == null || amount <= 0 || _selectedBiller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields with valid data.')),
      );
      return;
    }

    if (amount > _balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance.')),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Bill Payment'),
          content: Text(
              'Are you sure you want to pay \$${amount.toStringAsFixed(2)} for your $_selectedBiller bill (Bill Number: $billNumber)?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Deduct the amount from the balance
                setState(() {
                  _balance -= amount; // Update the balance
                  _transactionManager.addTransaction(
                      'Paid bill for $_selectedBiller (Bill Number: $billNumber)', amount);
                });

                // Clear the input fields
                _billNumberController.clear();
                _amountController.clear();

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paid \$${amount.toStringAsFixed(2)} to $_selectedBiller bill (Bill Number: $billNumber).')),
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
        title: const Text('Pay Bill'),
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
                      "Pay Your Bill",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select Biller'),
                      value: _selectedBiller,
                      items: _billers.map((String biller) {
                        return DropdownMenuItem<String>(
                          value: biller,
                          child: Text(biller),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBiller = newValue; // Update selected biller
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _billNumberController,
                      decoration: InputDecoration(
                        labelText: 'Bill Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                      onPressed: () => _payBill(context), // Call the pay bill logic
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Pay Bill',
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
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
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
