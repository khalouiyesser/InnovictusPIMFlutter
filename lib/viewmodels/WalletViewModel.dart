import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Models/Transaction%20.dart';
import '../models/Wallet.dart';

class WalletViewModel extends ChangeNotifier {
 //***************************************************************************************** */
 Wallet? wallet;
  bool isLoading = false;
  String? errorMessage;

  Future<void> connectWallet(String accountId, String privateKey) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    const String apiUrl = "http://192.168.1.17:5000/connectProfile"; 
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"accountId": accountId, "privateKey": privateKey}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        wallet = Wallet(
          accountId: accountId,
          privateKey: privateKey,
        );
      } else {
        errorMessage = jsonDecode(response.body)['message'];
        print("aaaaaaaaaaaaaaaaaaa");
        print(errorMessage);
      }
    } catch (e) {
      print("bbbbbbbbbbbbbbbbbbb");
      print(e);
      errorMessage = "Failed to connect wallet. Please try again.";
    }

    isLoading = false;
    notifyListeners();
  }

//***************************************************************************************** */
  String _tokenBalance = "0";
  String get tokenBalance => _tokenBalance;

  Future<void> fetchTokenBalance(String accountId) async {
    try {
      final response = await http.get(Uri.parse("http://192.168.1.17:5000/tokenBalance/$accountId"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _tokenBalance = data["balance"].toString();
        notifyListeners();
      } else {
        throw Exception("Failed to fetch balance: ${response.reasonPhrase}");
      }
    } catch (error) {
      print(" ❌ Error fetching token balance: $error");
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


}