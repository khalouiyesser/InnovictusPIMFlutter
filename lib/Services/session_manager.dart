import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:piminnovictus/Models/User.dart';

class SessionManager {
  static const String _keyToken = 'user_token';
  static const String _keyUser = 'user_data';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  final _storage = const FlutterSecureStorage();
 static const String _keyRecentUsers = 'recent_users';
  static const int maxRecentUsers = 5;
  // Singleton pattern
  static final SessionManager _instance = SessionManager._internal();
  
  factory SessionManager() {
    return _instance;
  }
  
  SessionManager._internal();

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
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: token),
      _storage.write(key: _keyRefreshToken, value: userData['refreshToken']),
      _storage.write(key: _keyUserId, value: userData['userId']),
      _storage.write(key: _keyUserData, value: json.encode(userData)),
    ]);
    
    // Add user to recent users list
    await addRecentUser(userData);
  }

  // Get user token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    String? userStr = await _storage.read(key: _keyUser);
    if (userStr != null && userStr.isNotEmpty) {
      return json.decode(userStr);
    }
    return null;
  }

   // Check if user is logged in
  Future<bool> isLoggedIn() async {
    String? token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Get all session data
  Future<Map<String, dynamic>?> getSessionData() async {
    String? userDataStr = await _storage.read(key: _keyUserData);
    if (userDataStr != null && userDataStr.isNotEmpty) {
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
  }

 Future<User?> getCurrentUser() async {
    final userData = await getSessionData();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  // Update specific user data field
  Future<void> updateUserData(String key, dynamic value) async {
    final userData = await getUserData() ?? {};
    userData[key] = value;
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

}