import 'package:flutter/foundation.dart';
import 'package:piminnovictus/Models/Auth/signup_response.dart';
import 'package:piminnovictus/Services/AuthController.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthController _authController;
  bool _isLoading = false;
  String? _error;

  SignupViewModel({AuthController? authController})
      : _authController = authController ?? AuthController();

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<SignupResponse?> signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String packId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authController.signupSimple(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        packId: packId,
      );

      return response;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
