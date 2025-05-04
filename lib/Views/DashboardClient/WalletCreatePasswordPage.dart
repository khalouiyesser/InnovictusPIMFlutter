import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/ViewModels/WalletViewModel.dart';
import 'package:piminnovictus/Views/DashboardClient/WalletPage.dart';
import 'package:piminnovictus/Views/DashboardClient/WalletPasswordPage.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';

const kGreen = Color(0xFF29E33C);

class WalletCreatePasswordPage extends StatefulWidget {
  @override
  _WalletCreatePasswordPageState createState() =>
      _WalletCreatePasswordPageState();
}

class _WalletCreatePasswordPageState extends State<WalletCreatePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;
  String _passwordStrength = '';

  bool get _isButtonEnabled =>
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text == _passwordController.text;

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.currentTheme ?? ThemeData.light();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlurredRadialBackground(
        height: screenHeight,
        child: Container(
          height: screenHeight, // Force la hauteur à prendre tout l'écran

          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 80),
                    Image.asset(
                      'assets/logo01.png',
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Greeno Wallet',
                      style: theme.textTheme.headlineLarge
                          ?.copyWith(fontSize: screenWidth * 0.04),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The future starts here',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontSize: screenWidth * 0.04),
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
                        //fillColor: const Color(0xFF2B273C),
                        hintText: 'Password',
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: screenWidth * 0.03,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontSize: screenWidth * 0.04),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Strength: $_passwordStrength',
                          style: TextStyle(
                            color: _passwordStrength == "Weak"
                                ? Colors.red
                                : _passwordStrength == "Medium"
                                    ? Colors.orange
                                    : Colors.green,
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
                        //fillColor: const Color(0xFF2B273C),
                        hintText: 'Confirm Password',
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: screenWidth * 0.03,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontSize: screenWidth * 0.04),
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
                        onPressed: _isButtonEnabled
                            ? () async {
                                final walletPassword =
                                    _passwordController.text.trim();
                                await secureStorage.write(
                                    key: 'walletPassword',
                                    value: walletPassword);
                                    //final userId = await secureStorage.read(key: 'userId');
                                    final userId = "67fc0fc891dd216a7100505e"; // make sure it's already stored
                                    final walletId = await secureStorage.read(key: 'accountId');
                                if (userId != null && walletId != null) {
                                  // Call the API to update the wallet
                                  // final WalletViewModel walletVM = WalletViewModel();
                                  // await walletVM.affectWallet(userId, walletId);

                                  // Navigate to WalletPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WalletPage()),
                                  );
                                } else {
                                  print("///////////////////////////////////////////////////////////////  userId or walletId is null");
                                }
                                print("///////////////////////////////////////////////////////////////  userId or walletId :");
                                print(userId);print(walletId);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF29E33C),
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
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
