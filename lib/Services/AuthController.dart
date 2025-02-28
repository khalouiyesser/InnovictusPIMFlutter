import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:piminnovictus/Models/Auth/signup_response.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/Services/session_manager.dart';

class AuthController {
  final Const con = Const();
  late final String api;
  final SessionManager _sessionManager = SessionManager();

  // Instance de Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '213262949474-n621113ftol42lpfuv4dbppc0m9prm68.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
    ],
  );

  AuthController() : api = Const().url;

  /// Fonction pour LoginSimple de mot de passe
  /* Future<Map<String, dynamic>> loginSimple(String email,String password) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print(response.body);
final responseData = json.decode(response.body);
      
      // Save session data after successful login
      await _sessionManager.saveSession(
        token: responseData['accessToken'],
        userData: {
          'email': email,
          'userId': responseData['userId'],
          'refreshToken': responseData['refreshToken'],
        },
      );
      
      return responseData;
            } else {
        throw Exception('Échec de l\'envoi de l\'OTP: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de l\'OTP: $e');
    }
  }*/
  Future<Map<String, dynamic>?> getUserDetails(
      String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$api/auth/user/$userId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch user details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }

  Future<Map<String, dynamic>?> updateUser(
      String userId, String name, String email, String phoneNumber) async {
    try {
      final response = await http.patch(
        Uri.parse("$api/auth/update-user"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'id': userId,
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<Map<String, dynamic>> loginSimple(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        // Fetch user details after successful login
        final userDetails = await getUserDetails(
            responseData['userId'], responseData['accessToken']);

        // Save complete session data
        await _sessionManager.saveSession(
          token: responseData['accessToken'],
          userData: {
            'email': email,
            'userId': responseData['userId'],
            'refreshToken': responseData['refreshToken'],
            'name': userDetails?['name'], // Add name from user details
            // Add any other user fields you need
          },
        );

        return responseData;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<SignupResponse> signupSimple({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String packId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'packId': packId,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return SignupResponse.fromJson(responseData);
      } else {
        throw Exception('Signup failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during signup: $e');
    }
  }

/*
  /// Fonction pour signupSimple de mot de passe
  Future<Map<String, dynamic>> signupSimple(
      String firstName, String lastName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$api/auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': firstName,
          'Name': lastName,
          'password': password
        }),
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
*/
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
  Future<Map<String, dynamic>> resetPassword(
      String resetToken, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse("$api/auth/reset-password"),
        headers: {'Content-Type': 'application/json'},
        body:
            json.encode({'resetToken': resetToken, 'newPassword': newPassword}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          print(response);
          return json.decode(response.body);
        } else {
          return {
            "message":
                "Mot de passe changé avec succès, mais aucune réponse du serveur."
          };
        }
      } else {
        throw Exception('Erreur: ${response.body}');
      }
    } catch (e) {
      print("Erreur lors de la requête: $e");
      throw Exception('Erreur lors de l\'envoi de la requête: $e');
    }
  }

  Future<UserCredential?> signUpWithGoogle(BuildContext context) async {
    try {
      // Première étape : Déconnexion pour éviter les conflits
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      // Démarrer le processus de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("❌ Connexion Google annulée par l'utilisateur.");
        return null;
      }

      try {
        // Obtenir les détails d'authentification
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Créer les identifiants Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Connexion à Firebase
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        if (userCredential.user != null) {
          print("✅ Connexion réussie : ${userCredential.user?.email}");

          // Envoyer les données au backend si nécessaire
          try {
            final response = await http.post(
              Uri.parse("$api/auth/google-login"),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'email': googleUser.email,
                'name': googleUser.displayName,
                'googleId': googleUser.id,
                'photoUrl': googleUser.photoUrl,
              }),
            );

            if (response.statusCode == 200) {
              // Navigation vers le Dashboard
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      BottomNavBarExample(googleId: googleUser.id),
                ),
              );
              return userCredential;
            }
          } catch (e) {
            print("⚠️ Erreur lors de l'enregistrement backend: $e");
          }
        }

        return userCredential;
      } catch (authError) {
        print("❌ Erreur d'authentification Google: $authError");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec de l'authentification Google")),
        );
        return null;
      }
    } catch (e) {
      print("❌ Erreur lors de la connexion Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la connexion Google")),
      );
      return null;
    }
  }

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    try {
      // Première étape : Déconnexion pour éviter les conflits
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();

      // Démarrer le processus de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      print(
          "11111111111111111111111111111111111111111111111111111 $googleUser");

      if (googleUser == null) {
        print("❌ Connexion Google annulée par l'utilisateur.");
        return null;
      }

      try {
        // Obtenir les détails d'authentification
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Créer les identifiants Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Connexion à Firebase
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        if (userCredential.user != null) {
          print("✅ Connexion réussie : ${userCredential}");

          // Envoyer les données au backend si nécessaire
          try {
            final response = await http.post(
              Uri.parse("$api/auth/loginGoogle"),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'email': googleUser.email,
                'googleId': googleUser.id,
              }),
            );

            if (response.statusCode != 200) {
              // Navigation vers le Dashboard
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      BottomNavBarExample(googleId: googleUser.id),
                ),
              );
              return userCredential;
            }
          } catch (e) {
            print("⚠️ Erreur lors de l'enregistrement backend: $e");
          }
        }

        return userCredential;
      } catch (authError) {
        print("❌ Erreur d'authentification Google: $authError");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec de l'authentification Google")),
        );
        return null;
      }
    } catch (e) {
      print("❌ Erreur lors de la connexion Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la connexion Google")),
      );
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
