import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:piminnovictus/Models/Auth/signup_response.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
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

/*Future<SignupResponse> signupSimple({
  required String name,
  required String email,
  required String password,
  required String phoneNumber,
  required String packId,
  String? idGoogle, // Nouveau paramètre optionnel
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
        'idGoogle': idGoogle, // Inclure idGoogle s'il est fourni
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
}*/

Future<SignupResponse> signupSimple({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String packId,
    BuildContext? context,
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
        final signupResponse = SignupResponse.fromJson(responseData);
        
        // Extract userId from response (adjust field name if needed)
        final String userId = responseData['userId'] ?? responseData['_id'] ?? '';
        
        // Get token from response (adjust field name if needed)
        final String token = responseData['accessToken'] ?? responseData['token'] ?? '';
        
        // Save session immediately after signup
        await _sessionManager.saveSession(
          token: token,
          userData: {
            'email': email,
            'userId': userId,
            'name': name,
            'phoneNumber': phoneNumber,
            'refreshToken': responseData['refreshToken'] ?? '',
            // Add any other user fields you need
          },
        );
        
        // Navigate to main screen if context is provided
        if (context != null) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                //ajbouni//BottomNavBarExample(),
              LoginView(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
        
        return signupResponse;
      } else {
        throw Exception('Signup failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during signup: $e');
    }
  }



  /// Fonction pour l'oubli de mot de passe
  Future<Map<String, dynamic>> forgotPassword(String email) async {

    print("forgot pressed");
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

  /// Fonction pour supprimer user
  Future deleteUserWithProfiles(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse("$api/auth/deleteUser/$userId"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 199 && response.statusCode < 300) {
        print(response.body);
        return "user deleted";
      } else {
        throw Exception('Échec de suppression de user : ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi de requete: $e');
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

/*
  /// Signup with google
  Future<SignupResponse?> signUpWithGoogle(BuildContext context) async {
    try {
      print("🔄 Déconnexion des sessions existantes...");
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut(); // Utilisez directement l'instance
      await Future.delayed(Duration(seconds: 1));

      print("🚀 Tentative de connexion avec Google...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("❌ Connexion Google annulée par l'utilisateur.");
        return null;
      }


      
      // Envoi des données au backend
       
      final response = await http.post(
        Uri.parse("$api/auth/signupGoogle"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': googleUser.email,
          'name': googleUser.displayName,
          'idGoogle': googleUser.id,
          'photoUrl': googleUser.photoUrl,
          'packId': "67be43394925465e90de0b98",
        }),
      );
    

      print("📩 Réponse brute du backend : ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        if (responseData is List && responseData.isNotEmpty) {
          print("✅ Inscription réussie sur le backend !");
          return SignupResponse.fromJson(responseData[0]);
        } else if (responseData is Map<String, dynamic>) {
          return SignupResponse.fromJson(responseData);
        } else {
          print("❌ Réponse inattendue du backend.");
        }
      } else {
        throw Exception('❌ Échec de l\'inscription Google : ${response.body}');
      }

    } catch (e, stackTrace) {
      print("❌ Erreur lors de la connexion Google: $e");
      print(stackTrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
      return null;
    }
  }
*/
Future<SignupResponse?> signUpWithGoogle(BuildContext context) async {
  try {
    print("🔄 Déconnexion des sessions existantes...");
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    await Future.delayed(Duration(seconds: 1));
    
    print("🚀 Tentative de connexion avec Google...");
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      print("❌ Connexion Google annulée par l'utilisateur.");
      return null;
    }
    
    // Obtenir les jetons d'authentification Google (important pour la persistance)
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    
    // Envoi des données au backend
    final response = await http.post(
      Uri.parse("$api/auth/signupGoogle"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': googleUser.email,
        'name': googleUser.displayName,
        'idGoogle': googleUser.id,
        'photoUrl': googleUser.photoUrl,
        'packId': "67be43394925465e90de0b98",
      }),
    );
    
    print("📩 Réponse brute du backend : ${response.body}");
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      SignupResponse signupResponse;
      
      Map<String, dynamic> userData;
      String userId = '';
      
      if (responseData is List && responseData.isNotEmpty) {
        print("✅ Inscription réussie sur le backend !");
        signupResponse = SignupResponse.fromJson(responseData[0]);
        userData = responseData[0];
        userId = responseData[0]['_id'] ?? '';
      } else if (responseData is Map<String, dynamic>) {
        signupResponse = SignupResponse.fromJson(responseData);
        userData = responseData;
        userId = responseData['_id'] ?? '';
      } else {
        print("❌ Réponse inattendue du backend.");
        throw Exception("Format de réponse inattendu");
      }
      
      print("🔐 Sauvegarde de la session utilisateur avec ID: $userId");
      
      // Utiliser idToken de Google comme token d'authentification
      final String authToken = idToken ?? 'google_auth_$userId';
      
      // Sauvegarder toutes les données de l'utilisateur plus le token Google
      await _sessionManager.saveSession(
        token: authToken,
        userData: {
          ...userData, // Inclure toutes les données du backend
          'email': googleUser.email,
          'userId': userId,
          'idGoogle': googleUser.id,
          'name': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
          'idToken': idToken, // Stocker le token d'authentification Google
        },
      );
      
      print("✅ Session sauvegardée avec succès");
      
      // Rediriger vers l'écran principal
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            //ajbouni//BottomNavBarExample(),
            LoginView(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      
      return signupResponse;
    } else {
      throw Exception('❌ Échec de l\'inscription Google : ${response.body}');
    }
    
  } catch (e, stackTrace) {
    print("❌ Erreur lors de la connexion Google: $e");
    print(stackTrace);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur: ${e.toString()}")),
    );
    return null;
  }
}
 Future<Map<String, dynamic>> loginWithGoogle(BuildContext context) async {
  try {
    print("🔄 Déconnexion des sessions existantes...");
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    await Future.delayed(Duration(seconds: 1));

    print("🚀 Tentative de connexion avec Google...");
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      print("❌ Connexion Google annulée par l'utilisateur.");
      return {};
    }

    print("11111111111111111111111111111111111111111111111111111111111 $googleUser");
    // Envoi des données au backend
    final response = await http.post(
      Uri.parse("$api/auth/loginGoogle"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': googleUser.email,
        'idGoogle': googleUser.id,
      }),
    );

    print("📩 Réponse brute du backend : ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);
      
      // Based on your response, we need to create a proper userData map
      // The response doesn't have accessToken or userId like simple login
      await _sessionManager.saveSession(
        // Since token is not provided in the Google response, we'll use a placeholder
        // You may need to adjust your backend to provide tokens or implement another approach
        token: 'google_auth_${responseData['_id']}', // Using _id as a fallback
        userData: {
          'email': responseData['email'],
          'userId': responseData['_id'], // Using _id from response as userId
          'refreshToken': 'google_auth_refresh', // Placeholder
          'name': responseData['name'],
          'idGoogle': responseData['idGoogle'],
          // Add other fields as needed
        },
      );
      
      // Navigate to BottomNavBarExample
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              //ajbouni//BottomNavBarExample(),
              LoginView(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      
      return responseData;
    } else {
      throw Exception('❌ Échec de la connexion Google : ${response.body}');
    }
  } catch (e, stackTrace) {
    print("❌ Erreur lors de la connexion Google: $e");
    print(stackTrace);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur de connexion: ${e.toString()}")),
    );
    return {};
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