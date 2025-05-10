import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/AuthViews/web_view_page.dart';
import 'package:piminnovictus/Views/Users/webViewCreateProfile.dart';

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
print("emil $email");
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





// // Méthode principale pour créer un profil et lancer le paiement
//   Future<void> createProfileAndPay({
//     required BuildContext context,
//     required String packId,
//     required String name,
//     required String imagePath,
//   }) async {
//     try {
//
//       print("11111111111111111111111111111111111111111111111111111111111111111111");
//       // Création du profil
//       final profileResult = await createProfile(
//         packId: packId,
//         name: name,
//         imagePath: imagePath,
//       );
//
//       print(profileResult);
//       if (profileResult['success'] != true) {
//         throw Exception(profileResult['message'] ?? 'Erreur inconnue.');
//       }
//
//       final profile = profileResult['profile'] as Map<String, dynamic>;
//       final profileId = profile['_id'] as String;
//
//       // Récupération des infos utilisateur
//       final String? email = await SessionManager().getEmail();
//       final String? userId = await SessionManager().getUserId();
//
//       if (email == null || userId == null) {
//         throw Exception("Utilisateur non authentifié.");
//       }
//
//       print("0000000000000000000000000000000000000000000000000000000000000000000000000000");
//       // Appel au paiement
//       await openPaymentYesser(
//         context: context,
//         packId: packId,
//         userId: userId,  // <--- AJOUTÉ
//         email: email,
//         profileId: profileId,
//       );
//     } catch (e) {
//       debugPrint('❌ Error in createProfileAndPay: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Erreur: ${e.toString()}')),
//       );
//     }
//   }

  // static Future<void> openPaymentProfiley(
  //     BuildContext context,
  //     String packId,
  //     String name,
  //     String email,
  //     String userId,
  //     ) async {
  //   final String apiUrl = "${Const().url}/stripe-payment/create-session/profile";
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "packId": packId,
  //         "name": name,
  //         "userId": userId,
  //         "email": email,
  //       }),
  //     );
  //
  //     print("🔍 packId: $packId");
  //     print("📧 email: $email");
  //     print("📨 Response Status: ${response.statusCode}");
  //     print("📨 Response Body: ${response.body}");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       final String paymentUrl = data["url"];
  //
  //       if (paymentUrl.isNotEmpty) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => WebViewPageYesser(
  //               url: paymentUrl,
  //               userEmail: email,
  //               packId: packId,
  //               name: name,
  //               imagePath: 'assets/user.jpg',
  //             ),
  //           ),
  //         );
  //       } else {
  //         throw Exception("Payment URL is empty");
  //       }
  //     } else {
  //       throw Exception("Failed to fetch payment URL. Status Code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("❌ Error: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error opening payment page")),
  //     );
  //   }
  // }


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


  Future<Map<String, dynamic>> createProfile({
    required String packId,
    required String name,
    required String imagePath,
  }) async {
    print("55555555555555555555555555555555555555555555555555555555555555555555555");

    try {
      // 1. Obtenir l'userId de manière asynchrone
      String? userId = await SessionManager().getUserId();  // Utilisation de await

      // 2. Valider les paramètres requis
      if (packId.isEmpty || name.isEmpty || userId == null || userId.isEmpty) {
        throw ArgumentError("Tous les paramètres requis doivent être fournis");
      }

      // 3. Créer l'URL avec le packId
      final String apiUrl = "${Const().url}/profile";

      debugPrint("🔄 Création du profil avec packId: $packId");
      debugPrint("📝 Données du profil: name=$name, image=$imagePath, user=$userId");

      // 4. Préparer les données de la requête
      final requestData = {
        "name": name,
        "image": imagePath,
        "userId": userId,
        "packId": packId
      };

      // 5. Envoyer la requête
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      debugPrint("📡 Réponse du serveur: ${response.statusCode}");
      debugPrint("📦 Corps de la réponse: ${response.body}");

      // 6. Traiter la réponse
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return {
          "success": true,
          "message": data["message"] ?? "Profil créé avec succès",
          "pdfUrl": data["pdfUrl"] ?? "",
          "profile": data["profile"] ?? {},
        };
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          "success": false,
          "message": errorData["message"] ?? "Échec de la création du profil",
          "errorCode": response.statusCode,
        };
      }
    } on http.ClientException catch (e) {
      debugPrint("❌ Erreur réseau: ${e.message}");
      return {
        "success": false,
        "message": "Erreur réseau: ${e.message}",
      };
    } on FormatException catch (e) {
      debugPrint("❌ Erreur de format: $e");
      return {
        "success": false,
        "message": "Erreur de traitement des données",
      };
    } catch (e) {
      debugPrint("❌ Erreur inattendue: $e");
      return {
        "success": false,
        "message": "Une erreur inattendue s'est produite",
      };
    }
  }


}