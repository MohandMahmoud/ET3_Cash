import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBalanceVisible = true;
  bool _isSavingsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Hero(
              tag: 'userAvatar', // Unique tag for the Hero
              child: ClipOval(
                child: Image.asset(
                  'assets/images/1724928422745.jpeg',
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blueAccent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back, Mohand!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildBalanceCard(
                  title: 'Current Balance',
                  amount: '\$1,250.00',
                  isVisible: _isBalanceVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildBalanceCard(
                  title: 'Savings Balance',
                  amount: '\$4,700.00',
                  isVisible: _isSavingsVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isSavingsVisible = !_isSavingsVisible;
                    });
                  },
                ),
                const SizedBox(height: 30),
                _buildActionsRow(context), // Add Action Buttons
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Drawer Design
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.indigoAccent,
            ),
            accountName: const Text(
              'Mohand Mahmoud',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: const Text(
              '+20 1124762559',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/FB_IMG_1698781339946.jpg',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _buildDrawerItem(Icons.person, 'Profile', context, '/Profile'),
          _buildDrawerItem(Icons.account_balance_wallet, 'Deposit', context, '/deposit'),
          _buildDrawerItem(Icons.remove_circle, 'Withdraw', context, '/withdraw'),
          _buildDrawerItem(Icons.send, 'Send Money', context, '/send_money'),
          _buildDrawerItem(Icons.favorite, 'Donate', context, '/donate'),
          _buildDrawerItem(Icons.payments, 'Pay Bill', context, '/pay_bill'),
          _buildDrawerItem(Icons.card_giftcard, 'Create Virtual Card', context, '/create_virtual_card'),
          _buildDrawerItem(Icons.savings, 'Create Savings Account', context, '/savings_account'),
          _buildDrawerItem(Icons.clear_all, 'Transactions History', context, '/clear_transactions'),
          _buildDrawerItem(Icons.logout, 'Logout', context, '/login'),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, BuildContext context, String routeName) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigoAccent),
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  // Redesigned Balance Card with Gradient and Shadow
  Widget _buildBalanceCard({
    required String title,
    required String amount,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  title == 'Current Balance'
                      ? Icons.account_balance_wallet_outlined
                      : Icons.savings_outlined,
                  size: 40,
                  color: Colors.indigoAccent,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isVisible ? amount : '',
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.indigoAccent,
              ),
              onPressed: onToggleVisibility,
            ),
          ],
        ),
      ),
    );
  }

  // Actions Row with Additional Buttons
  Widget _buildActionsRow(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(context, 'Deposit', Icons.account_balance_wallet, '/deposit'),
            _buildActionButton(context, 'Withdraw', Icons.remove_circle, '/withdraw'),
            _buildActionButton(context, 'Send Money', Icons.send, '/send_money'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(context, 'Donate', Icons.favorite, '/donate'),
            _buildActionButton(context, 'Pay Bill', Icons.payments, '/pay_bill'),
            _buildActionButton(context, 'Virtual Card', Icons.card_giftcard, '/create_virtual_card'),
          ],
        ),
        const SizedBox(height: 130),
      ],
    );
  }

  // Action Button Builder
  Widget _buildActionButton(BuildContext context, String label, IconData icon, String route) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.indigoAccent),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
