import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piminnovictus/Services/Const.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final String pendingSignupId;
  String? selectedPackId;
  bool isLoading = false;
  String? error;
  late final String api;

  SubscriptionViewModel({required this.pendingSignupId}) : api = Const().url {
    // Initialize with static pack ID
    selectedPackId = "67bf583d11b99e1b6875689f";
  }

  Future<bool> updatePackForPendingSignup() async {
    try {
      isLoading = true;
      notifyListeners();

      // Construct the URL properly without quotes around the packId
      final url =
          '$api/auth/pending-signup/$pendingSignupId/pack/$selectedPackId';

      // Debug print
      print('Making API call to URL: $url');
      print('Selected Pack ID: $selectedPackId');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Debug print response
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseData['message'] == 'Pack updated successfully') {
        error = null;
        return true;
      } else {
        error = responseData['message'] ??
            'Failed to update pack. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Error during API call: $e'); // Debug print error
      error = 'An error occurred. Please check your connection and try again.';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectPack(String packId) {
    selectedPackId = "67bf583d11b99e1b6875689f"; // Always use static ID
    print('Pack selected: $selectedPackId'); // Debug print
    error = null;
    notifyListeners();
  }

  bool isPackSelected(String packId) {
    return selectedPackId == "67bf583d11b99e1b6875689f";
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
