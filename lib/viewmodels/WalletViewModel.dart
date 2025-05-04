import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Models/Transaction%20.dart';
import 'package:piminnovictus/Services/Const.dart';
import '../models/Wallet.dart';

class WalletViewModel extends ChangeNotifier {
final String baseBcUrl = "${Const().urlBlockChain}";
final String baseUrl = "${Const().url}";
 //***************************************************************************************** */
 Wallet? wallet;
  bool isLoading = false;
  String? errorMessage;
  
  Future<void> connectWallet(String accountId, String privateKey) async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();

  String apiUrl = "$baseBcUrl/connectProfile"; 

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"accountId": accountId, "privateKey": privateKey}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      wallet = Wallet(
        accountId: accountId,
        privateKey: privateKey,
      );
    } else {
      if (response.headers['content-type']?.contains('application/json') == true) {
        errorMessage = jsonDecode(response.body)['message'];
      } else {
        errorMessage = "Server returned an error (${response.statusCode}).";
      }
      print("Error message from backend: $errorMessage");
    }
  } catch (e) {
    print("Exception caught: $e");
    errorMessage = "Failed to connect wallet. Error: $e";
  }

  isLoading = false;
  notifyListeners();
}


//***************************************************************************************** */
  
String _tokenBalance = "0";
String get tokenBalance => _tokenBalance;

Future<void> fetchTokenBalance(String operatorAccountId, String operatorPrivateKey) async {
  try {
    final uri = Uri.parse(
      "$baseBcUrl/tokenBalance"
      "?operatorAccountId=$operatorAccountId&operatorPrivateKey=$operatorPrivateKey",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _tokenBalance = data["balance"].toString();
      notifyListeners();
    } else {
      throw Exception("Failed to fetch balance: ${response.reasonPhrase}");
    }
  } catch (error) {
    print("❌ Error fetching token balance: $error");
  }
}


Future<void> affectWallet(String userId, String wallet) async {
  final Uri url = Uri.parse('$baseUrl/auth/$userId/wallet'); // Adjust base path as needed
  print('affectWallet from walletviemodel called here !!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'wallet': wallet,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Wallet updated successfully: $data');
    } else {
      print('Failed to update wallet. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error updating wallet: $e');
  }
}

  //***************************************************************************************** */

  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  //bool get isLoading => _isLoading;

  Future<void> loadTransactions(String accountId) async {
    _isLoading = true;
    notifyListeners();

    _transactions = await Transaction.fetchTransactions(accountId);

    _isLoading = false;
    notifyListeners();
  } 
/******************************************* */


}