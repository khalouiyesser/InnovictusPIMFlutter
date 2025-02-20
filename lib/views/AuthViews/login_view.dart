import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/viewmodels/WeatherAPI/bloc/weather_bloc_bloc.dart';
import 'dart:ui';

import '../../Services/AuthController.dart';
import '../DashboardClient/Bottom_bar.dart';
import '../Users/forgot_password_view.dart';
import 'RegisterView.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with WidgetsBindingObserver {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _emailError = null;
  String? _passwordError = null;
  late AuthScreenTheme _theme;
  bool _isPasswordVisible = false;

  AuthController auth = AuthController();

  @override
  void initState() {
    super.initState();
    _updateTheme();
    // S'enregistre pour écouter les changements de luminosité du système
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Mettre à jour le thème quand la luminosité du système change
    if (mounted) {
      setState(() {
        _updateTheme();
      });
    }
  }

  void _updateTheme() {
    _theme = AuthScreenThemeDetector.getTheme();
  }

  Future<void> _navigateToDashboard() async {
    try {
      final position = await _determinePosition();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => WeatherBlocBloc()..add(FetchWeather(position)),
            child: BottomNavBarExample(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible d'obtenir la localisation: $e")),
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Les permissions de localisation sont définitivement refusées');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = "Email cannot be empty";
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(value)) {
        _emailError = "Enter a valid email";
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = "Password cannot be empty";
      } else if (value.length < 6) {
        _passwordError = "Password must be at least 6 characters";
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background avec dégradé
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _theme.backgroundGradientColors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: isDarkMode
                  ? Image.asset("assets/Pulse.png", fit: BoxFit.cover)
                  : null, // Utilise l'image uniquement en mode sombre
            ),
          ),

          // Centered form content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email input field
                  TextField(
                    controller: this.emailController,
                    onChanged: (value) => _validateEmail(value),
                    style: TextStyle(color: _theme.textColor),
                    decoration: InputDecoration(
                      errorText: _emailError,
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: AuthScreenThemeDetector.isSystemDarkMode()
                            ? _theme.hintTextColor
                            : Colors.black54,
                      ),
                      filled: true,
                      fillColor: _theme.fieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.white, width: 1),

                        //borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: _theme.primaryColor, width: 1),
                      ),
                      contentPadding: EdgeInsets.only(left: 20),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password input field
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,

                    // obscureText: true,
                    onChanged: (value) => _validatePassword(value),
                    style: TextStyle(color: _theme.textColor),
                    decoration: InputDecoration(
                      errorText: _passwordError,
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: AuthScreenThemeDetector.isSystemDarkMode()
                            ? _theme.hintTextColor
                            : Colors.black54,
                      ),
                      filled: true,
                      fillColor: _theme.fieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: _theme.primaryColor, width: 1),
                      ),
                      contentPadding: EdgeInsets.only(left: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _theme.textColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordView()),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: _theme.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Positioned Login Button at the bottom
          Positioned(
            bottom: 190,
            left: 20,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  this._validateEmail(emailController.text);
                  _validatePassword(passwordController.text);
                  bool ok = validateform();
                  if (!ok) return;

                  try {
                    Map<String, dynamic> response = await auth.loginSimple(
                        emailController.text, passwordController.text);

                    if (response.isNotEmpty) {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  BottomNavBarExample(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Échec de la connexion : ${response['message'] ?? 'Vérifiez vos identifiants'}")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Echec de connexion")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          // Google button
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  auth.signUpWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AuthScreenThemeDetector.isSystemDarkMode()
                      ? Color(0xFF2C2E2F).withOpacity(0.1)
                      : Colors.white.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: _theme.primaryColor,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                icon: Image.asset(
                  'assets/google.png',
                  height: 24,
                ),
                label: Text(
                  "Login with Google",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : _theme.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Sign up text
          Positioned(
            bottom: 50,
            left: 10,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You don't have an account yet? ",
                  style: TextStyle(
                    color: _theme.textColor,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  child: Text(
                    "sign up",
                    style: TextStyle(color: _theme.primaryColor, fontSize: 16),
                  ),
                )
              ],
            ),
          ),

          // Welcome back text
          Positioned(
            top: 80,
            left: 20,
            child: Text(
              "Welcome back",
              style: TextStyle(
                color: _theme.textColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: _theme.textColor.withOpacity(0.2),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // Login text
          Positioned(
            top: 120,
            left: 20,
            child: Text(
              "Login",
              style: TextStyle(
                color: _theme.textColor,
                fontSize: 27,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateform() {
    if (!emailController.text.isEmpty && !passwordController.text.isEmpty) {
      if (_emailError == null && _passwordError == null) {
        print("navigate to the dashboard page ");
        return true;
      }
    } else {
      print("conditions not matches");
      _validateEmail(emailController.text);
      _validatePassword(passwordController.text);
      return false;
    }

    return false;
  }
}
