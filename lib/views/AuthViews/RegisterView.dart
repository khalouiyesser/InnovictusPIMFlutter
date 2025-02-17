import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmPasswordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _acceptedTerms = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _firstNameError;
  String? _lastNameError;

  AuthController auth = AuthController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => _validateEmail(emailController.text));
    firstNameController.addListener(() => _validateFirstName(firstNameController.text));
    lastNameController.addListener(() => _validateLastName(lastNameController.text));
    passwordController.addListener(() {
      _validatePassword(passwordController.text);
      _validataConfirmPassword(ConfirmPasswordController.text);
    });
    ConfirmPasswordController.addListener(() => _validataConfirmPassword(ConfirmPasswordController.text));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _validateLastName(String value) {
    setState(() {
      _lastNameError = value.isEmpty ? "LastName cannot be empty" : value.length < 3 ? "LastName should be at least 3 characters" : null;
    });
  }

  void _validataConfirmPassword(String value) {
    setState(() {
      _confirmPasswordError = value.isEmpty ? "Confirm Password cannot be empty" : value != passwordController.text ? "Passwords don't match" : null;
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError = value.isEmpty ? "Email cannot be empty" : !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value) ? "Enter a valid email" : null;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordError = value.isEmpty ? "Password cannot be empty" : value.length < 6 ? "Password must be at least 6 characters" : null;
    });
  }

  void _validateFirstName(String value) {
    setState(() {
      _firstNameError = value.isEmpty ? "FirstName cannot be empty" : value.length < 3 ? "FirstName should be at least 3 characters" : null;
    });
  }

  void _submitForm() {
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

    if (ConfirmPasswordController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        _confirmPasswordError == null &&
        _passwordError == null &&
        _emailError == null &&
        _firstNameError == null &&
        _lastNameError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubscriptionCarousel(preselectedPackId: widget.packId)),
      );
    } else {
      _validateEmail(emailController.text);
      _validatePassword(passwordController.text);
      _validataConfirmPassword(ConfirmPasswordController.text);
      _validateFirstName(firstNameController.text);
      _validateLastName(lastNameController.text);
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Pulse.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
                Align(
  alignment: Alignment.centerLeft, // Aligner à gauche
  child: Padding(
    padding: EdgeInsets.only(left: screenWidth * 0.05), // Ajouter un padding à gauche
    child: Text(
      "Create An Account",
      style: TextStyle(
        color: Colors.white,
        fontSize: screenWidth * 0.07, // Taille de police responsive
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
                                SizedBox(height: screenHeight * 0.11),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: firstNameController,
                        hintText: "First Name",
                        errorText: _firstNameError,
                        onChanged: _validateFirstName,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: lastNameController,
                        hintText: "Last Name",
                        errorText: _lastNameError,
                        onChanged: _validateLastName,
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
                                style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035),
                                children: [
                                  TextSpan(text: 'I accept '),
                                  TextSpan(
                                    text: 'terms & conditions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const TermsAndConditionsScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'privacy policy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const PrivacyPolicyScreen(),
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
                              // color: Color.fromARGB(255, 31, 219, 59),
                              color: Colors.white,
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

                            auth.signUpWithGoogle();
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
                            backgroundColor: const Color.fromARGB(255, 31, 219, 59),
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
                            style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginView()),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.green, fontSize: screenWidth * 0.035),
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
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.red),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : controller.text.isNotEmpty ? Colors.green : Colors.red,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : controller.text.isNotEmpty ? Colors.green : Colors.transparent,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.only(left: screenWidth * 0.05),
      ),
    );
  }
}