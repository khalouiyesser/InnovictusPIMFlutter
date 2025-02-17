import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:http/http.dart' as http;

class AuthController {
  final Const con = Const();
  late final String api;

  // Instance de Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthController() : api = Const().url;


  /// Fonction pour LoginSimple de mot de passe
  Future<Map<String, dynamic>> loginSimple(String email,String password) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email,'password':password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Échec de l\'envoi de l\'OTP: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de l\'OTP: $e');
    }
  }

  /// Fonction pour signupSimple de mot de passe
  Future<Map<String, dynamic>> signupSimple(String firstName,String lastName,String email,String password) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email,'password':password,'name':firstName,'lastName':lastName,'password':password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Échec de l\'envoi de l\'OTP: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de l\'OTP: $e');
    }
  }



  /// Fonction pour l'oubli de mot de passe
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/forgot-password"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Échec de l\'envoi de l\'OTP: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de l\'OTP: $e');
    }
  }

  /// Fonction pour resetPassword de mot de passe
  Future<Map<String, dynamic>> resetPassword(String resetToken, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse("$api/auth/reset-password"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'resetToken': resetToken, 'newPassword': newPassword}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          print(response);
          return json.decode(response.body);
        } else {
          return {"message": "Mot de passe changé avec succès, mais aucune réponse du serveur."};
        }
      } else {
        throw Exception('Erreur: ${response.body}');
      }
    } catch (e) {
      print("Erreur lors de la requête: $e");
      throw Exception('Erreur lors de l\'envoi de la requête: $e');
    }
  }


  /// Connexion avec Google
  Future<UserCredential?> signUpWithGoogle() async {
    try {
      // Démarrer le processus de connexion Google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        print("❌ Connexion Google annulée par l'utilisateur.");
        return null;
      }

      // Extraction des informations utilisateur
      String displayName = gUser.displayName ?? "Nom inconnu";
      String email = gUser.email;
      String id = gUser.id;
      String? photoUrl = gUser.photoUrl;  // Peut être null
      String? serverAuthCode = gUser.serverAuthCode;  // Peut être null

      // Affichage des valeurs récupérées
      print("🔹 Nom : $displayName");
      print("📧 Email : $email");
      print("🆔 ID : $id");
      print("🖼️ Photo : $photoUrl");
      print("🔑 Auth Code : $serverAuthCode");

      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication gAuth;
      try {
        gAuth = await gUser.authentication;
      } catch (authError) {
        print("❌ Erreur lors de l'obtention de l'authentification Google: $authError");
        return null;
      }

      print("🔑 Google Auth Token: ${gAuth.accessToken}");
      print("🆔 Google ID Token: ${gAuth.idToken}");

      if (gAuth.accessToken == null || gAuth.idToken == null) {
        print("❌ Les tokens Google sont invalides.");
        return null;
      }

      // Créer des identifiants pour Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Vérifier si FirebaseAuth est initialisé avant d'appeler signInWithCredential
      final FirebaseAuth authInstance = FirebaseAuth.instance;
      final UserCredential? userCredential = await authInstance.signInWithCredential(credential);

      if (userCredential != null) {
        print("🔥 Connexion réussie : ${userCredential.user?.email}");
        print("✅ UID : ${userCredential.user?.uid}");
      } else {
        print("⚠️ Problème lors de l'authentification Firebase.");
      }

      // Vérification null safety
      if (userCredential == null) {
        print("⚠️ Erreur : userCredential est null !");
        return null;
      }

      return userCredential;
    } catch (e) {
      print("❌ Erreur lors de la connexion Google: $e");
      return null;
    }
  }
   Future<String?> createPaymentIntent(int amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/payment"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'currency': currency}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['client_secret']; // Récupère le client_secret
      } else {
        print('Erreur Stripe: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      return null;
    }
  }


}
