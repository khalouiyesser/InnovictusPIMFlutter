import 'dart:ffi';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:piminnovictus/Models/User.dart';

class SessionManager {
  static const String _keyToken = 'user_token';
  static const String _keyUser = 'user_data';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyEmail = 'user_email';
  static const String _keyPhoneNumber = 'user_phoneNumber';
  static const String _keyUserData = 'user_data';
  static const String _keyUserProfiles = 'user_profiles'; //
// Clé pour le champ isLogged
  static const String _keyIsLogged = 'isLogged';



  final _storage = const FlutterSecureStorage();
  static const String _keyRecentUsers = 'recent_users';
  static const int maxRecentUsers = 5;
  // Singleton pattern
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();


  // Setter pour isLogged
  Future<void> setIsLogged(bool isLogged) async {
    await _storage.write(key: _keyIsLogged, value: isLogged.toString());
    print("Login status saved: $isLogged");
  }

// Getter pour isLogged
  Future<bool> getIsLogged() async {
    String? isLoggedStr = await _storage.read(key: _keyIsLogged);
    return isLoggedStr != null && isLoggedStr.toLowerCase() == 'true';
  }

  // Check if user is logged in
  // Vérifier si l'utilisateur est connecté (par isLogged et token)
  Future<bool> isLoggedIn() async {
    // Vérifier si l'utilisateur est marqué comme connecté dans le stockage
    bool isLogged = await getIsLogged();

    // Vérifier si un token valide est présent
    String? token = await getAccessToken();  // Vous devez définir cette méthode ailleurs

    // Retourner true si l'utilisateur est connecté (par isLogged ou par le token)
    return isLogged && (token != null && token.isNotEmpty);
  }

  Future<bool> isLoggedInYesser() async {
    // Vérifier si l'utilisateur est marqué comme connecté dans le stockage
    bool isLogged = await getIsLogged();

    // Vérifier si un token valide est présent
    // String? token = await getAccessToken();  // Vous devez définir cette méthode ailleurs

    // Retourner true si l'utilisateur est connecté (par isLogged ou par le token)
    return isLogged;
  }

  // Save user session
  /* Future<void> saveSession({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: token),
      _storage.write(key: _keyRefreshToken, value: userData['refreshToken']),
      _storage.write(key: _keyUserId, value: userData['userId']),
      _storage.write(key: _keyUserData, value: json.encode(userData)),
    ]);
  }
*/
  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    print("userData before saving: $userData");
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: token),
      _storage.write(key: _keyRefreshToken, value: userData['refreshToken']),
      _storage.write(key: _keyUserId, value: userData['userId']),
      _storage.write(key: _keyUserData, value: json.encode(userData)),
    ]);
    print(userData);
    // Add user to recent users list
    await addRecentUser(userData);
  }


  Future<void> saveSessionAA({

    required Map<String, dynamic> userData,
  }) async {
    print("userData before saving: $userData");
    await Future.wait([
      _storage.write(key: _keyUserId, value: userData['userId']),
      _storage.write(key: _keyUserData, value: json.encode(userData)),
    ]);
    print(userData);
    // Add user to recent users list
    await addRecentUser(userData);
  }

  // Get user token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// Récupère les données utilisateur sauvegardées
  Future<Map<String, dynamic>?> getUserData() async {
    String? userStr = await _storage.read(key: _keyUserData);
    if (userStr != null && userStr.isNotEmpty) {
      print(json.decode(userStr));
      return json.decode(userStr);
    }
    return null;
  }



  // Get all session data
  Future<Map<String, dynamic>?> getSessionData() async {
    String? userDataStr = await _storage.read(key: _keyUserData);
    if (userDataStr != null && userDataStr.isNotEmpty) {
      var decodedData = json.decode(userDataStr);

      print('Session Data: $decodedData'); // Print the full session data
      print('User name from session: ${decodedData['user_phoneNumber']}');
      return json.decode(userDataStr);
    }
    return null;
  }

  // Clear session (logout)
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyUserId),
      _storage.delete(key: _keyUserData),

    ]);
    this.setIsLogged(false);
  }

  Future<User?> getCurrentUser() async {
    final userData = await getSessionData();
    if (userData != null) {
      var user = User.fromJson(userData);

      print('Current User: ${user.name}'); // Print the user's name

      // Print specifically the name
      return User.fromJson(userData);
    }
    return null;
  }

  // Update specific user data field
  Future<void> updateUserData(String key, dynamic value) async {
    final userData = await getUserData() ?? {};
    userData[key] = value;
    print("helooooooooooooooooooooooooooooooooooooooo ");
    await _storage.write(key: _keyUser, value: json.encode(userData));
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  // Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<void> addRecentUser(Map<String, dynamic> userData) async {
    final List<Map<String, dynamic>> recentUsers = await getRecentUsers();

    // Remove if user already exists
    recentUsers.removeWhere((user) => user['userId'] == userData['userId']);

    // Add new user at the beginning
    recentUsers.insert(0, userData);

    // Keep only the most recent users
    if (recentUsers.length > maxRecentUsers) {
      recentUsers.removeLast();
    }

    await _storage.write(
      key: _keyRecentUsers,
      value: json.encode(recentUsers),
    );
  }

  // Get list of recent users
  Future<List<Map<String, dynamic>>> getRecentUsers() async {
    final String? recentUsersStr = await _storage.read(key: _keyRecentUsers);
    if (recentUsersStr != null && recentUsersStr.isNotEmpty) {
      final List<dynamic> decoded = json.decode(recentUsersStr);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

Future<void> saveUser(User user) async {
  final Map<String, dynamic> userData = {
    'userId': user.id,
    'name': user.name,
    'email': user.email,
    'phoneNumber': user.phoneNumber,
  };

  print("Saving user to session: $userData"); // Log pour débogage
  await _storage.write(key: _keyUserData, value: jsonEncode(userData));
  await _storage.write(key: _keyUserId, value: user.id);
  await addRecentUser(userData);
  print("User saved successfully"); // Log pour débogage

}




  Future<void> saveEmail(String email) async {
    // Sauvegarder l'email de l'utilisateur dans la session
    await _storage.write(key: _keyEmail, value: email);
    print("Email de l'utilisateur sauvegardé dans la session : $email");
  }
  Future<String?> getEmail() async {
    return await _storage.read(key: _keyEmail);
  }



  Future<void> setDonne(Map<String, dynamic> response) async {
    // Extraire les données utilisateur et les profils du JSON
    final user = response['user'];
    final profiles = response['profiles'];

    // Sauvegarder les données de l'utilisateur et des profils dans la session
    await Future.wait([
      _storage.write(key: _keyUserData, value: json.encode(user)),
      _storage.write(key: _keyUserProfiles, value: json.encode(profiles)),
    ]);
    print("Donnees utilisateur et profils sauvegardées dans la session");
  }

}
