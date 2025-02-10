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

  /// Connexion avec Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Démarrer le processus de connexion Google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        print("Connexion Google annulée par l'utilisateur.");
        return null;
      }

      print(gUser);
      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Créer des identifiants pour Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );


      // Se connecter avec Firebase
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print("Erreur lors de la connexion Google: $e");
      return null;
    }
  }
}
