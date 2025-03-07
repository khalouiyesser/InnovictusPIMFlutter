import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import 'package:piminnovictus/Views/AuthViews/privacy_policy.dart';
import 'package:piminnovictus/Views/AuthViews/terms_and_conditions.dart';
import '../../Models/Auth/signup_response.dart';
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
          title: Text(
            AppLocalizations.of(context).translate('error'),
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
              child: Text(
                AppLocalizations.of(context).translate('ok'),
                style: const TextStyle(color: Colors.white),
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
        packId: "67bbcbabc538c6915580df5a", // Make sure to handle null packId
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

  Future<void> _handleSignupGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("🚀 Début du processus d'inscription avec Google...");
      final SignupResponse? signupResponse =
          await auth.signUpWithGoogle(context);

      if (!mounted) return; // Vérifie si le widget est encore actif

      if (signupResponse != null && signupResponse.pendingSignupId.isNotEmpty) {
        print(
            "✅ Inscription Google réussie, redirection vers SubscriptionCarousel...");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionCarousel(
              preselectedPackId: "67bbcbabc538c6915580df5a",
              pendingSignupId: signupResponse.pendingSignupId,
            ),
          ),
        );
      } else {
        print("❌ Échec de l'inscription Google, réponse invalide.");
        _showErrorDialog(
            "L'inscription avec Google a échoué. Veuillez réessayer.");
      }
    } catch (e) {
      if (!mounted) return;
      print("❌ Erreur lors de l'inscription Google: $e");
      _showErrorDialog("Une erreur est survenue : ${e.toString()}");
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
          ? AppLocalizations.of(context).translate('fullNameEmpty')
          : value.length < 3
              ? AppLocalizations.of(context).translate('fullNameTooShort')
              : null;
    });
  }

// Validation de la confirmation du mot de passe
  void _validataConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError =
            AppLocalizations.of(context).translate('confirmPasswordEmpty');
      } else if (value != passwordController.text) {
        _confirmPasswordError =
            AppLocalizations.of(context).translate('passwordsDontMatch');
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _emailError = value.isEmpty
          ? AppLocalizations.of(context).translate('emailEmpty')
          : !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(value)
              ? AppLocalizations.of(context).translate('invalidEmail')
              : null;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _passwordError = value.isEmpty
          ? AppLocalizations.of(context).translate('passwordEmpty')
          : value.length < 6
              ? AppLocalizations.of(context).translate('passwordTooShort')
              : null;
    });
  }

  void _validatePhoneNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _PhoneNumberError =
            AppLocalizations.of(context).translate('phoneNumberEmpty');
      } else if (!RegExp(r"^[259]\d{7}$").hasMatch(value)) {
        _PhoneNumberError =
            AppLocalizations.of(context).translate('invalidPhoneNumber');
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
            title: Text(
              AppLocalizations.of(context).translate('termsRequired'),
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              AppLocalizations.of(context).translate('pleaseAcceptTerms'),
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 31, 219, 59),
                ),
                child: Text(
                  AppLocalizations.of(context).translate('ok'),
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
            AppLocalizations.of(context).translate('termsAndConditions'),
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
                AppLocalizations.of(context).translate('close'),
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
            AppLocalizations.of(context).translate('privacyPolicy'),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 31, 219, 59),
              ),
              child: Text(
                AppLocalizations.of(context).translate('close'),
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
                      AppLocalizations.of(context).translate('createAccount'),
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
                        hintText:
                            AppLocalizations.of(context).translate('fullName'),
                        errorText: _fullNameError,
                        onChanged: _validatefullName,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: emailController,
                        hintText:
                            AppLocalizations.of(context).translate('email'),
                        errorText: _emailError,
                        onChanged: _validateEmail,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: PhoneNumberController,
                        hintText: AppLocalizations.of(context)
                            .translate('phoneNumber'),
                        errorText: _PhoneNumberError,
                        onChanged: _validatePhoneNumber,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: passwordController,
                        hintText:
                            AppLocalizations.of(context).translate('password'),
                        errorText: _passwordError,
                        onChanged: _validatePassword,
                        obscureText: true,
                        screenWidth: screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: ConfirmPasswordController,
                        hintText: AppLocalizations.of(context)
                            .translate('confirmPassword'),
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
                                  TextSpan(
                                      text: AppLocalizations.of(context)
                                          .translate('iAccept')),
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate('termsAndConditions'),
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
                                  TextSpan(
                                      text: AppLocalizations.of(context)
                                          .translate('and')),
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate('privacyPolicy'),
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
                            AppLocalizations.of(context)
                                .translate('signUpWithGoogle'),
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
                            _handleSignupGoogle();
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
                            AppLocalizations.of(context).translate('next'),
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
                            AppLocalizations.of(context)
                                .translate('haveAccount'),
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
                              AppLocalizations.of(context).translate('login'),
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
    bool isPassword = hintText.toLowerCase().contains(
        AppLocalizations.of(context).translate('password').toLowerCase());
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: isPassword
          ? (hintText == AppLocalizations.of(context).translate('password')
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
                  hintText == AppLocalizations.of(context).translate('password')
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
                    if (hintText ==
                        AppLocalizations.of(context).translate('password')) {
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
