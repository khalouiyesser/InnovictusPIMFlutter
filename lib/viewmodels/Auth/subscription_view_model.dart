import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piminnovictus/Services/Const.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final String pendingSignupId;
  final String profileId;

  String? selectedPackId;
  bool isLoading = false;
  String? error;
  late final String api;

  SubscriptionViewModel({required this.pendingSignupId , required this.profileId}) : api = Const().url {
    // Initialize with static pack ID
    selectedPackId = "selectedPackId";

  }
  Future<bool> updatePackForPendingSignup() async {
    try {
      isLoading = true;
      notifyListeners();

      final url =
          '$api/auth/pending-signup/$pendingSignupId/pack/$selectedPackId';

      print('Making API call to URL: $url');
      print('Selected Pack ID: $selectedPackId');
  print("signuid" +pendingSignupId);
        print("signuid" +profileId);
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseData['message'] == 'Pack updated successfully') {
        error = null;
        return true;
      } else if (response.statusCode == 403 &&
          responseData['message']
              .toString()
              .contains("Email verification required")) {
        // Special handling for email verification
        error = "EMAIL_VERIFICATION_REQUIRED";
        notifyListeners();
        return false;
      } else {
        error = responseData['message'] ??
            'Failed to update pack. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Error during API call: $e');
      error = 'An error occurred. Please check your connection and try again.';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectPack(String packId) {
    selectedPackId = packId; // Always use static ID
    print('Pack selected: $selectedPackId'); // Debug print
    error = null;
    notifyListeners();
  }

  bool isPackSelected(String packId) {
    return selectedPackId == packId;
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
