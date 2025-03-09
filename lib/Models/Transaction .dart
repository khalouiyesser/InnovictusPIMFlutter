import 'dart:convert';
import 'package:http/http.dart' as http;

class Transaction {
  final DateTime date;
  final double amount;
  final double power;
  final double price;
  final String type;

  Transaction({
    required this.date,
    required this.amount,
    required this.power,
    required this.price,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      power: (json['power'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      type: json['type'],
    );
  }

  static Future<List<Transaction>> fetchTransactions(String accountId) async {
    final url = Uri.parse('http://192.168.1.17:5000/fetchTransactions/$accountId');
    print("*********** fetchTransactions started********************");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Transaction> transactions = (data['transactions'] as List)
            .map((json) => Transaction.fromJson(json))
            .toList();
            print("*********** fetchTransactions 200********************");
        return transactions;
      } else {
        print("*********** Failed to load transactions ********************");
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      print("*********** Failed to load transactions  ENDED ********************");
      return [];
    }
  }



}
