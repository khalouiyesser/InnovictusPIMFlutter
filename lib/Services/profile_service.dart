
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/Services/session_manager.dart';

class ProfileService {
  final String baseUrl;
  final SessionManager _sessionManager;

  ProfileService({required this.baseUrl, required SessionManager sessionManager})
      : _sessionManager = sessionManager;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _sessionManager.getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<ProfileModel>> getProfiles() async {
    try {
      final userId = await _sessionManager.getUserId();
      if (userId == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/profile/user/$userId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProfileModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load profiles');
      }
    } catch (e) {
      throw Exception('Error fetching profiles: $e');
    }
  }

  Future<ProfileModel> createProfile(String name, String? imageUrl) async {
    try {
      final userId = await _sessionManager.getUserId();
      if (userId == null) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: await _getHeaders(),
        body: json.encode({
          'name': name,
          'image': imageUrl,
          'userId': userId,
          'packId': 'default'
        }),
      );

      if (response.statusCode == 201) {
        return ProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create profile');
      }
    } catch (e) {
      throw Exception('Error creating profile: $e');
    }
  }

  // Other API methods...
}