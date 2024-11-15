import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_app/lib/models/user.dart';
import 'package:new_app/lib/models/transaction.dart';
import 'package:new_app/lib/models/virtual_card.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000'; // Use 10.0.2.2 for Android emulator

  // Login method
  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),  // Ensure this matches your Django endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the user data if login is successful
      final jsonResponse = jsonDecode(response.body);
      return User.fromJson(jsonResponse);  // Ensure you have a fromJson method in your User model
    } else {
      throw Exception('Failed to login: ${response.statusCode} ${response.body}');
    }
  }

  // Fetch users
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users/'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['results']; // Adjust based on your API response
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode} ${response.body}');
    }
  }

  // Fetch transactions
  Future<List<Transaction>> fetchTransactions(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/transactions/?user_id=$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['results']; // Adjust based on your API response
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions: ${response.statusCode} ${response.body}');
    }
  }

  // Create a new transaction
  Future<void> createTransaction(Transaction transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create transaction: ${response.statusCode} ${response.body}');
    }
  }

  // Fetch virtual cards for a user
  Future<List<VirtualCard>> fetchVirtualCards(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/virtual_cards/?user_id=$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['results']; // Adjust based on your API response
      return data.map((json) => VirtualCard.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load virtual cards: ${response.statusCode} ${response.body}');
    }
  }

  // Create a new virtual card
  Future<void> createVirtualCard(VirtualCard virtualCard) async {
    final response = await http.post(
      Uri.parse('$baseUrl/virtual_cards/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(virtualCard.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create virtual card: ${response.statusCode} ${response.body}');
    }
  }
}
