/*import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../Services/AuthController.dart';
import '../DashboardClient/Bottom_bar.dart';
import '../Users/forgot_password_view.dart';
import 'RegisterView.dart';

// import 'package:piminnovictus/views/register_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _emailError = null;
  String? _passwordError = null;

  AuthController auth = AuthController();


  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = "Email cannot be empty";
        print("Email cannot be empty");
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(value)) {
        _emailError = "Enter a valid email";
        print("Enter a valid email");
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = "Password cannot be empty";
        print("Password cannot be empty");
      } else if (value.length < 6) {
        _passwordError = "Password must be at least 6 characters";
        print("Password must be at least 6 characters");
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
            final isDarkMode = themeProvider.isDarkMode;
 final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color fieldFillColor = isDarkMode 
                               ? Colors.white.withOpacity(0.2) 
                               : Colors.grey.withOpacity(0.1);
    final Color hintTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final Color primaryColor = MyThemes.primaryColor;
    final Color backgroundColor = isDarkMode 
                               ? MyThemes.secondaryColor 
                               : MyThemes.whiteColor;


    return Scaffold(
      resizeToAvoidBottomInset:
      false, // Disable resizing of the screen when keyboard appears
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Pulse.png", // Your background image
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),

          // Centered form content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To center the form
                children: [
                  // Email input field
                  TextField(
                    controller: this.emailController,
                    onChanged: (value) => _validateEmail(value),
                    decoration: InputDecoration(
                      errorText: _emailError,
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
// Bordure verte au focus
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                            color: Color(0xFF29E33C),
                            width: 1), // Bordure verte au focus
                      ),

                      contentPadding:
                      EdgeInsets.only(left: 20), // Décale le hint à droite
                    ),
                  ),
                  SizedBox(height: 20), // Space between fields

                  // Password input field
                  TextField(
                    controller: passwordController,
                    obscureText: true, // To hide the password text
                    onChanged: (value) => _validatePassword(value),
                    decoration: InputDecoration(
                      errorText: _passwordError,
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                            color: Color(0xFF29E33C),
                            width: 1), // Bordure verte au focus
                      ),

                      contentPadding:
                      EdgeInsets.only(left: 20), // Décale le hint à droite
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
                          color: const Color.fromARGB(255, 255, 255, 255),
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
            bottom: 150, // Distance from the bottom of the screen
            left: 20, // Align with the left
            right: 20, // Align with the right
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 80% width
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  this._validateEmail(emailController.text);
                  _validatePassword(passwordController.text);
                  bool ok = validateform();
                  if (!ok) return; // Empêche de continuer si le formulaire est invalide

                  try {
                    Map<String, dynamic> response = await auth.loginSimple(emailController.text, passwordController.text);

                    if (response.isNotEmpty) { // Vérifie si le login a réussi
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              BottomNavBarExample(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Échec de la connexion : ${response['message'] ?? 'Vérifiez vos identifiants'}")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Echec de connexion")),
                    );
                  }


                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 31, 219, 59), // Green background color
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
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // print("Login with Google");
                  auth.signUpWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C2E2F).withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Color(0xFF29E33C), // Couleur verte
                      width: 1, // Épaisseur de la bordure
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
                    color: const Color.fromARGB(221, 255, 255, 255),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 10, // Distance from the bottom of the screen
            left: 10, // Align with the left
            right: 20, // Align with the right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You don't have an account yet? ",
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                    fontSize: 14, // Adjust font size as needed
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("you should navigate to  sign up page ");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  child: Text(
                    "sign up",
                    style: TextStyle(
                      color: Colors.green, // Or another contrasting color
                      fontSize: 14, // Adjust font size as needed
                    ),
                  ),
                )
              ],
            ),
          ),

          // "Welcome back" text with subtle green glow effect
          Positioned(
            top: 80, // Adjust as needed
            left: 20, // Adjust as needed
            child: Text(
              "Welcome back",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0), // Green shadow
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // "Login" text with green effect
          Positioned(
            top: 120, // Adjust as needed
            left: 20, // Adjust as needed
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
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
*/
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
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

if (response['accessToken'] != null) {                      Navigator.of(context).pushReplacement(
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