import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Views/AuthViews/web_view_page.dart';

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
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("✅ Finalize signup success: ${responseData['message']}");
    } else {
      print('❌ Error finalizing signup: ${response.statusCode}');
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