import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import '../AuthViews/login_view.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'otp.dart';
import 'dart:async';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with WidgetsBindingObserver {
  late AuthScreenTheme _theme;
  bool isPhoneInput = false;
  bool isEmailInput = false;
  bool phoneError = false;
  bool isLoading = false; // State for managing loading
  bool isFullScreenLoading = false; // State for full screen loading
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final AuthController con = AuthController();
  bool isEmail(String email) {
    // Regular expression to validate an email address
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (emailRegex.hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  bool isTunisianNumber(String text) {
    final RegExp tunisianNumberRegex = RegExp(r'^(2|4|5|9)\d{7}$');
    return tunisianNumberRegex.hasMatch(text);
  }

  @override
  void initState() {
    super.initState();
    _updateTheme();
    // Register to listen for system brightness changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    // Update theme when system brightness changes
    if (mounted) {
      setState(() {
        _updateTheme();
      });
    }
  }

  void _updateTheme() {
    _theme = AuthScreenThemeDetector.getTheme();
  }

  // Method to send reset email with full screen loading
  Future<void> _sendResetEmail() async {
    if (!isEmailInput ||
        emailController.text.isEmpty ||
        !isEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context).translate("enterValidEmail"))),
      );
      return;
    }

    // Show full screen loading with message
    setState(() {
      isFullScreenLoading = true;
    });

    try {
      // Wait for 5 seconds to show the loading screen
      await Future.delayed(const Duration(seconds: 5));

      Map<String, dynamic> response =
          await con.forgotPassword(emailController.text);

      if (response.containsKey('resetToken') && response.containsKey('code')) {
        String resetToken = response['resetToken'];
        int code = response['code'];

        print("Email: ${emailController.text}");
        print("ResetToken: $resetToken");
        print("Code: $code");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OTPPage(
              email: emailController.text,
              resetToken: resetToken,
              code: code,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "${AppLocalizations.of(context).translate("connectionError")} : ${response['message'] ?? AppLocalizations.of(context).translate("missingData")}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "${AppLocalizations.of(context).translate("connectionError")} : $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isFullScreenLoading = false;
        });
      }
    }
  }

  // Method to send OTP by SMS
  Future<void> _sendOTPBySMS() async {
    if (!isPhoneInput || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context).translate("enterPhoneNumber"))),
      );
      return;
    }

    if (!isTunisianNumber(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context).translate("invalidPhoneNumber"))),
      );
      return;
    }

    // Show full screen loading
    setState(() {
      isFullScreenLoading = true;
    });

    try {
      // Wait for 5 seconds to show the loading screen
      await Future.delayed(const Duration(seconds: 5));

      // Replace this part with the actual API call for SMS OTP
      await con.forgotPassword(phoneController.text);

      // Navigation after receiving OTP
      // To be adjusted according to your actual implementation
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "${AppLocalizations.of(context).translate("connectionError")} : $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isFullScreenLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background
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

          // Main content
          Center(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 1),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("forgotPassword"),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _theme.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 100),
                      const SizedBox(height: 30),

                      isEmailInput
                          ? TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate("enterEmail"),
                                hintStyle:
                                    TextStyle(color: _theme.hintTextColor),
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.white),
                                filled: true,
                                fillColor: _theme.fieldFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              style: TextStyle(color: _theme.textColor),
                              onSubmitted: (_) => _sendResetEmail(),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEmailInput = true;
                                  isPhoneInput = false;
                                  phoneController.clear();
                                });
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: _theme.fieldFillColor,
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.email_outlined,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate("sendOtpEmail"),
                                      style: TextStyle(
                                          color: _theme.textColor,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                      const SizedBox(height: 80),

                      // Continue button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(0xFF29E33C),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (isEmailInput) {
                                    await _sendResetEmail();
                                  } else if (isPhoneInput) {
                                    await _sendOTPBySMS();
                                  } else {
                                    // Prompt user to select a method
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)
                                                .translate("selectMethod")),
                                      ),
                                    );
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("continueButton"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(height: 15),

                      buildActionButton(
                        text: AppLocalizations.of(context)
                            .translate("backToLogin"),
                        backgroundColor: Colors.transparent,
                        textColor: _theme.textColor,
                        borderColor: Color(0xFF29E33C),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (LoginView())),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Full screen loading overlay
          if (isFullScreenLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF29E33C),
                        strokeWidth: 4,
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Email being sent...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildOptionButton(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required VoidCallback onSubmitted,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: hintText.contains("phone")
            ? TextInputType.phone
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        onSubmitted: (value) => onSubmitted(),
      ),
    );
  }
}
