import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:piminnovictus/Views/DashboardClient/WalletPage.dart';
import 'package:piminnovictus/Views/DashboardClient/WalletPasswordPage.dart';

class WalletCreatePasswordPage extends StatefulWidget {
  @override
  _WalletCreatePasswordPageState createState() => _WalletCreatePasswordPageState();
}

class _WalletCreatePasswordPageState extends State<WalletCreatePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;
  String _passwordStrength = '';
  
  bool get _isButtonEnabled => _passwordController.text.isNotEmpty && _confirmPasswordController.text == _passwordController.text;

  //ajbouni
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();


  void _validatePasswords() {
    setState(() {
      if (_confirmPasswordController.text != _passwordController.text) {
        _errorMessage = "Passwords do not match";
      } else {
        _errorMessage = null;
      }
    });
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length < 6) {
        _passwordStrength = "Weak";
      } else if (password.length < 10) {
        _passwordStrength = "Medium";
      } else {
        _passwordStrength = "Strong";
      }
    });
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF1A1625), // Dark background
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80), // Prevents elements from sticking to the top
              Image.asset(
                'assets/logo01.png', // Replace with actual asset
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                'Greeno Wallet',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'The future starts here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                onChanged: (value) {
                  _validatePasswords();
                  _checkPasswordStrength(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B273C),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Strength: $_passwordStrength',
                    style: TextStyle(
                      color: _passwordStrength == "Weak" ? Colors.red : _passwordStrength == "Medium" ? Colors.orange : Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                onChanged: (value) => _validatePasswords(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B273C),
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? () async {
                    final walletPassword = _passwordController.text.trim();
                    await secureStorage.write(key: 'walletPassword', value: walletPassword);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletPage()),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // Adjust for keyboard
            ],
          ),
        ),
      ),
    ),
  );
}
}
