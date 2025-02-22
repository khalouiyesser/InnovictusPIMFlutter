import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/profile.dart';

class ProfileSwitcherViewModel extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  ProfileModel? _currentProfile;
  bool _isLoading = false;
    List<User> recentUsers = [];

 Future<void> fetchRecentUsers() async {
    // Implement your logic to get recent users
  }
  
  // Method to select a user
  void selectUser(String userId) {
    // Implement your logic to switch to this user
  }
  List<ProfileModel> get profiles => _profiles;
  ProfileModel? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;

  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Here you would fetch profiles from your API/service
      // For example:
      // final profiles = await _profileService.getProfiles();
      _profiles = [
        ProfileModel(id: '1', name: 'Hadhemi Mahmoud', isSelected: true),
        ProfileModel(id: '2', name: 'SH Optique'),
      ];
      _currentProfile = _profiles.firstWhere((p) => p.isSelected);
    } catch (e) {
      print('Error loading profiles: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> switchProfile(String profileId) async {
    try {
      // Update selected profile in backend
      // await _profileService.switchProfile(profileId);
      
      _profiles = _profiles.map((profile) {
        return ProfileModel(
          id: profile.id,
          name: profile.name,
          imageUrl: profile.imageUrl,
          isSelected: profile.id == profileId,
        );
      }).toList();
      
      _currentProfile = _profiles.firstWhere((p) => p.isSelected);
      notifyListeners();
    } catch (e) {
      print('Error switching profile: $e');
    }
  }
}