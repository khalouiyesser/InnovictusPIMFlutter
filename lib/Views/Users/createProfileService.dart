import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/Users/webViewCreateProfile.dart';

import '../../Services/Const.dart';

class CreateProfileService {

  static Future<void> openPaymentProfile(BuildContext context,
      String? packId,
      String name,
      String email,
      String userId,) async {




    SessionManager _sessionManager = SessionManager();
    final user = await _sessionManager.getCurrentUser();
    // email = SessionManager().getEmail() as String;

    String? yesser = user?.email;

    print("2222222222222222222222222222222222222222222222222222222222222222222222222");
    print(email);
    print("333333333333333333333333333333333333333333333333");
    final String apiUrl = "${Const()
        .url}/stripe-payment/create-session/profile";





    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "packId": packId,
          "name": name,
          "userId": user?.id,
          "email": user?.email, // Email statique ici
        }),
      );

      print("🔍 packId: $packId");
      print("📧 email: khaluiyesser@gmail.com"); // Affiche l'email statique
      print("📨 Response Status: ${response.statusCode}");
      print("📨 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Assurez-vous que l'URL de paiement est bien récupérée
        final String? paymentUrl = data["url"]; // Vérifier la présence de l'URL
print("111111111111111111111111111111111111111111111111111111111111111111111111111111");
        print(paymentUrl);
        print("22222222222222222222222222222222222222222222222222222222222222222222222222222222222222");
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WebViewPageYesser(
                    url: paymentUrl,
                    packId: packId,
                    name: name,
                    imagePath: 'assets/user.jpg',
                  ),
            ),
          );
        } else {
          throw Exception("Payment URL is empty or null");
        }
      } else {
        throw Exception(
            "Failed to fetch payment URL. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening payment page")),
      );
    }
  }
}