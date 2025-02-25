import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import 'package:piminnovictus/Views/AuthViews/privacy_policy.dart';
import 'package:piminnovictus/Views/AuthViews/terms_and_conditions.dart';
import '../plan_subscription.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  final String? packId;
  const RegisterView({Key? key, this.packId}) : super(key: key);
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with WidgetsBindingObserver {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  late AuthScreenTheme _theme;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  bool _acceptedTerms = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _fullNameError;
  String? _PhoneNumberError;

  AuthController auth = AuthController();
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 8, 16, 9),
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 31, 219, 59),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignup() async {
    try {
      final signupResponse = await auth.signupSimple(
        name: fullNameController.text,
        email: emailController.text,
        password: passwordController.text,
        phoneNumber: PhoneNumberController.text,
        packId: "67bbcb92c538c6915580df58", // Make sure to handle null packId
      );

      // Handle successful signup
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionCarousel(
              preselectedPackId: widget.packId,
              pendingSignupId: signupResponse.pendingSignupId,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updateTheme();
    WidgetsBinding.instance.addObserver(this);
    emailController.addListener(() => _validateEmail(emailController.text));
    fullNameController
        .addListener(() => _validatefullName(fullNameController.text));
    PhoneNumberController.addListener(
        () => _validatePhoneNumber(PhoneNumberController.text));
    passwordController.addListener(() {
      _validatePassword(passwordController.text);
      _validataConfirmPassword(ConfirmPasswordController.text);
    });
    ConfirmPasswordController.addListener(
        () => _validataConfirmPassword(ConfirmPasswordController.text));
  }

  void _updateTheme() {
    _theme = AuthScreenThemeDetector.getTheme();
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void _validatefullName(String value) {
    setState(() {
      _fullNameError = value.isEmpty
          ? "FullName cannot be empty"
          : value.length < 3
              ? "FullName should be at least 6 characters"
              : null;
    });
  }

// Validation de la confirmation du mot de passe
  void _validataConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = "Confirm password cannot be empty";
      } else if (value != passwordController.text) {
        _confirmPasswordError = "Passwords don't match";
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError = value.isEmpty
          ? "Email cannot be empty"
          : !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(value)
              ? "Enter a valid email"
              : null;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordError = value.isEmpty
          ? "Password cannot be empty"
          : value.length < 6
              ? "Password must be at least 6 characters"
              : null;
    });
  }

  void _validatePhoneNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _PhoneNumberError = "Phone number cannot be empty";
      } else if (!RegExp(r"^[259]\d{7}$").hasMatch(value)) {
        _PhoneNumberError = "Phone must start with 2, 5 or 9 and have 8 digits";
      } else {
        _PhoneNumberError = null;
      }
    });
  }

  void _submitForm() async {
    if (!_acceptedTerms) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 8, 16, 9),
            title: const Text(
              'Terms & Conditions Required',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Please accept the terms and conditions to continue.',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 31, 219, 59),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate all fields
    _validateEmail(emailController.text);
    _validatePassword(passwordController.text);
    _validataConfirmPassword(ConfirmPasswordController.text);
    _validatefullName(fullNameController.text);
    _validatePhoneNumber(PhoneNumberController.text);

    if (ConfirmPasswordController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        PhoneNumberController.text.isNotEmpty &&
        _confirmPasswordError == null &&
        _passwordError == null &&
        _emailError == null &&
        _fullNameError == null &&
        _PhoneNumberError == null) {
      setState(() {
        _isLoading = true;
      });

      await _handleSignup();
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 8, 16, 9),
          title: Text(
            'Terms & Conditions',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Your terms and conditions text here...',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 31, 219, 59),
              ),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 8, 16, 9),
          title: Text(
            'Privacy Policy',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Your privacy policy text here...',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 31, 219, 59),
              ),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
                  : null,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
                Align(
                  alignment: Alignment.centerLeft, // Aligner à gauche
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            screenWidth * 0.05), // Ajouter un padding à gauche
                    child: Text(
                      "Create An Account",
                      style: TextStyle(
                        color: _theme.textColor,
                        fontSize:
                            screenWidth * 0.07, // Taille de police responsive
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.11),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: fullNameController,
                        hintText: "Full Name",
                        errorText: _fullNameError,
                        onChanged: _validatefullName,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: emailController,
                        hintText: "Email",
                        errorText: _emailError,
                        onChanged: _validateEmail,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: PhoneNumberController,
                        hintText: "Phonne Number",
                        errorText: _PhoneNumberError,
                        onChanged: _validatePhoneNumber,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: passwordController,
                        hintText: "Password",
                        errorText: _passwordError,
                        onChanged: _validatePassword,
                        obscureText: true,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: ConfirmPasswordController,
                        hintText: "Confirm Password",
                        errorText: _confirmPasswordError,
                        onChanged: _validataConfirmPassword,
                        obscureText: true,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.transparent,
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: _theme.textColor,
                                    fontSize: screenWidth * 0.035),
                                children: [
                                  TextSpan(text: 'I accept '),
                                  TextSpan(
                                    text: 'terms & conditions',
                                    style: TextStyle(
                                      color: _theme.textColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TermsAndConditionsScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'privacy policy',
                                    style: TextStyle(
                                      color: _theme.textColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PrivacyPolicyScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.06,
                        child: OutlinedButton.icon(
                          icon: Image.asset(
                            'assets/google.png',
                            height: screenHeight * 0.03,
                          ),
                          label: Text(
                            'Sign up with Google',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : _theme.textColor,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Color.fromARGB(255, 31, 219, 59),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            auth.signUpWithGoogle(context);
                            // print('Google sign-in pressed');
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 31, 219, 59),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You have an account? ",
                            style: TextStyle(
                                color: _theme.textColor,
                                fontSize: screenWidth * 0.035),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginView()),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: screenWidth * 0.035),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? errorText,
    required Function(String) onChanged,
    bool obscureText = false,
    required double screenWidth,
  }) {
    bool isPassword = hintText.toLowerCase().contains('password');

    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: isPassword
          ? (hintText == "Password"
              ? !_isPasswordVisible
              : !_isConfirmPasswordVisible)
          : false,
      style: TextStyle(color: _theme.textColor),
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.red),
        hintText: hintText,
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
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: errorText != null
                ? Colors.red
                : controller.text.isNotEmpty
                    ? _theme.primaryColor
                    : Colors.red,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: errorText != null
                ? Colors.red
                : controller.text.isNotEmpty
                    ? _theme.primaryColor
                    : Colors.white,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.only(left: screenWidth * 0.05),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  hintText == "Password"
                      ? (_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)
                      : (_isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                  color: _theme.textColor,
                ),
                onPressed: () {
                  setState(() {
                    if (hintText == "Password") {
                      _isPasswordVisible = !_isPasswordVisible;
                    } else {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    }
                  });
                },
              )
            : null,
      ),
    );
  }
}
