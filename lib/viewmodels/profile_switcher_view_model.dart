import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileSwitcherViewModel with ChangeNotifier {
  List<ProfileModel> _profiles = [];
  ProfileModel? _currentProfile;
  List<User> _recentUsers = [];
  bool _isLoading = false;
  final SessionManager _sessionManager = SessionManager();
  final String _baseUrl;
    // Getters
  List<ProfileModel> get profiles => _profiles;
  ProfileModel? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  List<User> get recentUsers => _recentUsers;
  Map<String, dynamic>? get currentProfileData => _currentProfileData;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Map<String, dynamic>? _currentProfileData;
  
  ProfileSwitcherViewModel() : _baseUrl = Const().url {
    _initializeLastProfile();
  }

 

  Future<void> _initializeLastProfile() async {
    try {
      // Get the last selected profile ID from SessionManager
      final sessionData = await _sessionManager.getSessionData();
      final lastProfileId = sessionData?['currentProfileId'];
      
      if (lastProfileId != null) {
        await loadProfiles();
        // Find and set the last selected profile
        final lastProfile = _profiles.firstWhere(
          (profile) => profile.id == lastProfileId,
          orElse: () => _profiles.first,
        );
        await switchProfile(lastProfile.id);
      }
    } catch (e) {
      print('Error initializing last profile: $e');
    }
  }

  Future<void> switchProfile(String profileId) async {
    _setLoading(true);
    try {
      // Update profile selection
      for (var profile in _profiles) {
        profile.isSelected = profile.id == profileId;
        if (profile.isSelected) {
          _currentProfile = profile;
        }
      }

      // Save current profile ID to session
      await _sessionManager.updateUserData('currentProfileId', profileId);
      
      // Load profile-specific data (e.g., packs)
      await _loadProfileData(profileId);
      
      // Update last used timestamp
      await _updateProfileLastUsed(profileId);
      
      notifyListeners();
    } catch (e) {
      print('Error switching profiles: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadProfileData(String profileId) async {
    try {
      final token = await _sessionManager.getAccessToken();
      if (token == null) return;

      // Load profile-specific data (adjust endpoint as needed)
      final response = await http.get(
        Uri.parse('$_baseUrl/profile/$profileId/data'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _currentProfileData = json.decode(response.body);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Future<void> _updateProfileLastUsed(String profileId) async {
    try {
      final token = await _sessionManager.getAccessToken();
      if (token == null) return;

      await http.patch(
        Uri.parse('$_baseUrl/profile/$profileId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'lastUsed': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      print('Error updating profile last used: $e');
    }
  }

  // Get profile-specific pack
  Future<Map<String, dynamic>?> getProfilePack() async {
    if (_currentProfile == null) return null;
    try {
      final token = await _sessionManager.getAccessToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$_baseUrl/profile/${_currentProfile!.id}/pack'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error loading profile pack: $e');
      return null;
    }
  }

  



  Future<void> loadRecentUsers() async {
    try {
      // Get current Firebase user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // You might want to implement your own logic to track recent users
      // For now, we'll just add the current user to the recent users list
      _recentUsers = [currentUser];
      notifyListeners();
    } catch (e) {
      print('Error loading recent users: $e');
    }
  }

  Future<void> selectUser(String uid) async {
    try {
      // Implement your logic for selecting a user
      // This might involve switching to a different user's profile
      final user = _recentUsers.firstWhere((u) => u.uid == uid);
      if (user != null) {
        // Add your user selection logic here
        print('Selected user: ${user.displayName}');
        notifyListeners();
      }
    } catch (e) {
      print('Error selecting user: $e');
    }
  }
  Future<void> createProfile(String name, String? imageUrl) async {
  _setLoading(true);
  try {
    final userId = await _sessionManager.getUserId();
    final token = await _sessionManager.getAccessToken();
    if (userId == null || token == null) return;

    final response = await http.post(
      Uri.parse('$_baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'image': imageUrl,
        'userId': userId,
        'packId': 'default',
        'createdAt': DateTime.now().toIso8601String(), // Add this line
      }),
    );

    if (response.statusCode == 201) {
      await loadProfiles();
    } else {
      print('Error creating profile: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error creating profile: $e');
  } finally {
    _setLoading(false);
  }
}
  Future<void> deleteProfile(String profileId) async {
    _setLoading(true);
    try {
      final token = await _sessionManager.getAccessToken();
      if (token == null) return;

      final response = await http.delete(
        Uri.parse('$_baseUrl/profile/$profileId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await loadProfiles();
      } else {
        print('Error deleting profile: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error deleting profile: $e');
    } finally {
      _setLoading(false);
    }
  }
List<ProfileModel> getRecentProfiles(int limit) {
    // Filter out the current profile and get the most recent ones
    return _profiles
        .where((profile) => profile.id != currentProfile?.id)
        .take(limit)
        .toList();
  }

  // Update the loadProfiles method to sort profiles by recent usage
  Future<void> loadProfiles() async {
    _setLoading(true);
    try {
      final userId = await _sessionManager.getUserId();
      final token = await _sessionManager.getAccessToken();
      
      if (userId == null || token == null) {
        _setLoading(false);
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/profile/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> profilesJson = json.decode(response.body);
        _profiles = profilesJson
            .map((json) => ProfileModel.fromJson(json))
            .toList();

        // Sort profiles by last used date if available
        _profiles.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));

        if (_currentProfile == null && _profiles.isNotEmpty) {
          _currentProfile = _profiles.first;
          _currentProfile!.isSelected = true;
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error loading profiles: $e');
    } finally {
      _setLoading(false);
    }
  }

  List<ProfileModel> get profilesSortedByCreationDate {
  // Create a copy of the profiles list to avoid modifying the original
  List<ProfileModel> sortedProfiles = List.from(_profiles);
  // Sort profiles by creation date (oldest to newest)
  sortedProfiles.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return sortedProfiles;
}

// If you want newest to oldest, use this version instead:
List<ProfileModel> get profilesSortedByCreationDateDesc {
  List<ProfileModel> sortedProfiles = List.from(_profiles);
  sortedProfiles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sortedProfiles;
}

  
}