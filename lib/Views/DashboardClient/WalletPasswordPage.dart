import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Views/DashboardClient/ConnectWallet.dart';
import 'package:piminnovictus/Views/DashboardClient/WalletPage.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';

class WalletPasswordPage extends StatefulWidget {
  @override
  _WalletPasswordPageState createState() => _WalletPasswordPageState();
}

class _WalletPasswordPageState extends State<WalletPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  Future<void> _checkPassword() async {
    String? storedPassword = await secureStorage.read(key: 'walletPassword');
    print("**************_check Wallet Password Srarted ********************");
    String enteredPassword = _passwordController.text.trim();

    if (storedPassword == null) {
      setState(() {
        print(
            "**************_check Wallet Password: storedPassword == null ********************");
        _errorMessage = "No password found. Please create one first.";
      });
    } else if (enteredPassword == storedPassword) {
      setState(() {
        _errorMessage = null;
      });
      print(
          "**************_check Wallet Password: enteredPassword == storedPassword ********************");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WalletPage()));
    } else {
      setState(() {
        print(
            "**************_check Wallet Password: Incorrect password. Please try again. ********************");
        _errorMessage = "Incorrect password. Please try again.";
      });
    }
    print("**************_check Wallet Password ENDED ********************");
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
        height: screenHeight, // Force la hauteur à prendre tout l'écran
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: screenHeight,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo01.png',
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Greeno Wallet',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontSize: screenWidth * 0.07),
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
                        onPressed: _checkPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF29E33C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sign in to GreenoWallet',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontSize: screenWidth * 0.03),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectWalletPage()));
                      },
                      child: Text(
                        'Forgot Password',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontSize: screenWidth * 0.03),
                      ),
                    ),
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
