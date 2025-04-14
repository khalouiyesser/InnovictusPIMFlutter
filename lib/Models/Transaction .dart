// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Transaction {
//   final DateTime date;
//   final double amount;
//   final double power;
//   final double price;
//   final String type;

//   Transaction({
//     required this.date,
//     required this.amount,
//     required this.power,
//     required this.price,
//     required this.type,
//   });

//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       date: DateTime.parse(json['date']),
//       amount: (json['amount'] as num).toDouble(),
//       power: (json['power'] as num).toDouble(),
//       price: (json['price'] as num).toDouble(),
//       type: json['type'],
//     );
//   }

//   static Future<List<Transaction>> fetchTransactions(String accountId) async {
//     final url = Uri.parse('$baseBcUrl/fetchTransactions/$accountId');
//     print("*********** fetchTransactions started********************");
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         List<Transaction> transactions = (data['transactions'] as List)
//             .map((json) => Transaction.fromJson(json))
//             .toList();
//             print("*********** fetchTransactions 200********************");
//         return transactions;
//       } else {
//         print("*********** Failed to load transactions ********************");
//         throw Exception('Failed to load transactions');
//       }
//     } catch (e) {
//       print('Error fetching transactions: $e');
//       print("*********** Failed to load transactions  ENDED ********************");
//       return [];
//     }
//   }

// /*************************************************** */
// static Future<List<Transaction>> mintTokens(String amount) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$baseBcUrl/mintTokens"),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'amount': amount,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         // You can modify this depending on the actual response structure
//         final transaction = Transaction.fromJson(data);
//         return [transaction]; // Returning a list of one transaction for simplicity
//       } else {
//         throw Exception('Failed to mint tokens');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Services/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;

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

  //final String baseBcUrl = "${Const().urlBlockChain}";
  static final String baseBcUrl = "${Const().urlBlockChain}";

  // Fetch transactions for a specific accountId
  static Future<List<Transaction>> fetchTransactions(String accountId) async {
    final url = Uri.parse('$baseBcUrl/fetchTransactions/$accountId');
    print("*********** fetchTransactions started ********************");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Transaction> transactions = (data['transactions'] as List)
            .map((json) => Transaction.fromJson(json))
            .toList();
        print("*********** fetchTransactions 200 ********************");
        return transactions;
      } else {
        print("*********** Failed to load transactions ********************");
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      print("*********** Failed to load transactions ENDED ********************");
      return [];
    }
  }

  // Mint Tokens API, adjust according to the response you expect
  static Future<String> mintTokens(int amount) async {
    try {
      final response = await http.post(
        Uri.parse("$baseBcUrl/mintTokens"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Assuming the response is just a success message or status
        print("API Minted Successfully ---------------------------------");
          final SocketService _socketService = SocketService();

late IO.Socket socket;
  String api = Const().urlSocket;
  socket = IO.io(api, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
  // 🔥 Function to send the reset topic
  socket.emit('message', {
    'topic': 'resetEnergy',
    'message': 'reset'  // your server can ignore the payload if not needed
  });



        return data['message'] ?? 'Minted Successfully'; // Return the message or status
      } else {
        print("API Failed to mint tokens ---------------------------------");
        throw Exception('Failed to mint tokens');
      }
    } catch (e) {
      print("API Error Error ---------------------------------");
      throw Exception('Error: $e');
    }
  }













}
