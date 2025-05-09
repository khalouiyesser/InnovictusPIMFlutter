import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/AuthViews/web_view_page.dart';

import '../Models/User.dart';

class PaymentService {
  static Future<void> openPayment(
      BuildContext context, String packId, String pendingSignupId, String email, String profileId) async {
    final String apiUrl = "${Const().url}/stripe-payment/create-session";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "packId": packId,
          "pendingSignupId": pendingSignupId,
          "profileId": profileId,
          "email": email,
        }),
      );
      print("🔍 packId: $packId");
      print("🔍 pendingSignupId: $pendingSignupId");
      print("🔍 profileId: $profileId");

      print("🔍 Response Status: ${response.statusCode}");
      print("🔍 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Accept 201 status
        final data = jsonDecode(response.body);
        final String paymentUrl = data["url"]; // ✅ Extract the correct URL

        if (paymentUrl.isNotEmpty) {
          // ✅ Open WebView with packId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(
                url: paymentUrl,
                pendingSignupId: pendingSignupId,
                defaultProfileId: profileId,
                userEmail: email,
                packId: packId, // Pass packId to WebViewPage
              ),
            ),
          );
        } else {
          throw Exception("Payment URL is empty");
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

  Future<void> finalizeSignup(String userId, String profileId) async {
    print("🔍 Finalizing signup for userId: $userId");
    final String apiUrl = "${Const().url}/auth/finalize-signup/$userId";

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}), // Vous pouvez ajouter des données dans le corps si nécessaire
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Récupérer les informations de l'utilisateur à partir de la réponse
      final user = responseData['user'];
      final String userId = user['_id'] ?? "";
      final String name = user['name'] ?? "";
      final String email = user['email'] ?? "";
      final String phoneNumber = user['phoneNumber'] ?? "";

      // Créez un objet User avec les données de l'utilisateur
      User userObj = User(
        id: userId,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      // Enregistrez l'utilisateur dans la session
      await SessionManager().saveUser(userObj);

      // Mettre à jour l'état de connexion à true
      await SessionManager().setIsLogged(true);

      print("✅ Finalize signup success: ${responseData['message']}");
      print("🔒 User saved to session: $userObj");
    } else {
      print('❌ Error finalizing signup: ${response.statusCode}');
    }
  }


  Future<Map<String, dynamic>> getUserData(String userId) async {
    print("🔍 Fetching user data for userId: $userId");
    final String apiUrl = "${Const().url}/auth/yesser/hetDonnee/$userId";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Exemple d'accès aux données
        print("✅ User name: ${responseData['user']['name']}");
        print("📧 Email: ${responseData['user']['email']}");
        print("🖼️ Image: ${responseData['user']['image']}");
        print("📱 Phone: ${responseData['user']['phoneNumber']}");

        // Retourner les données nécessaires (utilisateur et profils)
        return {
          'user': responseData['user'],
          'profiles': responseData['profiles'],
        };
      } else {
        print('❌ Error fetching user data: ${response.statusCode}');
        return {}; // Retourner un objet vide en cas d'erreur
      }
    } catch (e) {
      print('❌ Exception occurred: $e');
      return {}; // Retourner un objet vide en cas d'exception
    }
  }






  // Updated to use the dynamically provided packId
  Future<Map<String, dynamic>> sendConfirmationEmail(String packId, String email, String userName) async {
    try {
      final String apiUrl = "${Const().url}/packs/confirm/$packId";
      
      print("📧 Sending confirmation email with packId: $packId");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "userName": userName
        }),
      );
      
      print("📧 Mail Confirmation Status: ${response.statusCode}");
      print("📧 Mail Confirmation Response: ${response.body}");
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": data["message"] ?? "Email de confirmation envoyé avec succès",
          "pdfUrl": data["pdfUrl"] ?? ""
        };
      } else {
        return {
          "success": false,
          "message": "Failed to send confirmation email"
        };
      }
    } catch (e) {
      print("❌ Email Confirmation Error: $e");
      return {
        "success": false,
        "message": "Error: $e"
      };
    }
  }
}