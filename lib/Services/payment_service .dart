import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Views/AuthViews/web_view_page.dart';

class PaymentService {
  static Future<void> openPayment(BuildContext context, String packId, String pendingSignupId) async {
    final String apiUrl = "${Const().url}/stripe-payment/create-session"; 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "packId": packId,
          "pendingSignupId": pendingSignupId,
        }),
      );

    print("🔍 Response Status: ${response.statusCode}");
      print("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {  // ✅ Accept 201 status
        final data = jsonDecode(response.body);
        final String paymentUrl = data["url"]; // ✅ Extract the correct URL

        if (paymentUrl.isNotEmpty) {
          // ✅ Open WebView
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(url: paymentUrl),
            ),
          );
        } else {
          throw Exception("Payment URL is empty");
        }
      } else {
        throw Exception("Failed to fetch payment URL. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening payment page")),
      );
    }
  }
}