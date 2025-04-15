import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Views/AuthViews/web_view_page.dart';

class PaymentService {
static Future<void> openPayment(
    BuildContext context,
    String packId,
    String pendingSignupId,
        String defaultProfileId,

    String email,
    String profileId) async {
  final String apiUrl = "${Const().url}/stripe-payment/create-session";
    
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "packId": packId,
        "pendingSignupId": pendingSignupId,
        "email": email,
        "defaultProfileId": profileId,
      }),
    );
        
    print("🔍 Response Status: ${response.statusCode}");
    print("🔍 Response Body: ${response.body}");
        
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final String paymentUrl = data["url"];
            
      if (paymentUrl.isNotEmpty) {
        // Il serait bon d'ajouter le profileId dans votre WebViewPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              url: paymentUrl,
              pendingSignupId: pendingSignupId,
               defaultProfileId: profileId,
            ),
          ),
        );
      } else {
        throw Exception("Payment URL is empty");
      }
    } else {
      // Amélioration de la gestion d'erreur pour afficher le message d'erreur du backend
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData["message"] ?? "Unknown error occurred";
      throw Exception("Failed to fetch payment URL: $errorMessage");
    }
  } catch (e) {
    print("❌ Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error opening payment page: ${e.toString()}")),
    );
  }
}
  Future<void> finalizeSignup(String userId, String packId) async {
    final String apiUrl =
        "${Const().url}/auth/finalize-signup/$userId"; // Corrected const() usage
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        // Add any necessary data to send with the PATCH request
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Handle successful response
      print(responseData['message']); // Display success message
    } else {
      // Handle error response
      print('Error: ${response.statusCode}');
    }
  }
}
