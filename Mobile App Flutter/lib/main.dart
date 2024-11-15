import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/send_money_screen.dart';
import 'screens/donate_screen.dart';
import 'screens/pay_bill_screen.dart';
import 'screens/create_virtual_card_screen.dart';
import 'screens/savings_account_screen.dart';
import 'screens/clear_transactions_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cash App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const SplashScreen(), // Set splash screen as the home
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/deposit': (context) => const DepositScreen(),
        '/withdraw': (context) => const WithdrawScreen(),
        '/send_money': (context) => const SendMoneyScreen(),
        '/donate': (context) => const DonateMoneyScreen(),
        '/pay_bill': (context) => const PayBillScreen(),
        '/create_virtual_card': (context) => const CreateVirtualCardScreen(),
        '/savings_account': (context) => const CreateSavingsAccountScreen(),
        '/clear_transactions': (context) => const TransactionHistoryScreen(),
        '/change_password': (context) => ChangePasswordScreen(),
        '/Profile': (context) => const ProfileScreen(),
      },
    );
  }
}
