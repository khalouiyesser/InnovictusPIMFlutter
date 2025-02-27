import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import '../AuthViews/login_view.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'otp.dart';

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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final AuthController con = AuthController();
  bool isEmail(String email) {
    // Expression régulière pour valider une adresse e-mail
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
    // S'enregistre pour écouter les changements de luminosité du système
    WidgetsBinding.instance.addObserver(this);
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Disable resizing of the screen when keyboard appears
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
                  : null, // Utilise l'image uniquement en mode sombre
            ),
          ),
          Center(
            child: SafeArea(
              child: Center(
                // Centre le contenu
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centre verticalement
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centre horizontalement
                    mainAxisSize:
                        MainAxisSize.min, // Ajuste la taille au contenu
                    children: [
                      const SizedBox(height: 1),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).translate("forgotPassword"),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _theme.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 100),
                      // const SizedBox(height: 40),

                      /* isPhoneInput
                          ? TextField(
                              controller: phoneController,
                              keyboardType:
                                  TextInputType.phone, // Clavier numérique
                              decoration: InputDecoration(
                                hintText: "Enter your phone number",
                                hintStyle: TextStyle(
                                    color: _theme
                                        .hintTextColor), // HintText en blanc
                                prefixIcon: Icon(Icons.phone,
                                    color: Colors.white), // Icône téléphone
                                filled: true,
                                fillColor: _theme
                                    .fieldFillColor, // Couleur similaire au bouton
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      24.0), // Bordures arrondies
                                  borderSide: BorderSide(color: Colors.white),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .green), // Bordure verte au focus
                                ),
                              ),
                              style: TextStyle(
                                  color: _theme.textColor), // Texte en blanc
                              onSubmitted: (_) {
                                setState(() {
                                  isPhoneInput = false;
                                });
                              },
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPhoneInput = true;
                                  isEmailInput = false;
                                  emailController.clear();
                                });
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: _theme.fieldFillColor,
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: Colors.green, // Bordure verte
                                  ), // Bordure verte au focus
                                  // Bordures identiques
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble_outline,
                                        color: Colors.white), // Icône OTP
                                    SizedBox(width: 10),
                                    Text(
                                      "Send OTP via SMS",
                                      style: TextStyle(
                                          color: _theme.textColor,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            */

                      const SizedBox(height: 30),

                      isEmailInput
                          ? TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).translate("enterEmail"),
                                hintStyle:
                                    TextStyle(color: _theme.hintTextColor),
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.white),
                                filled: true,
                                fillColor: _theme.fieldFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      24.0), // Bordures arrondies
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .green), // Bordure verte au focus
                                ),
                              ),
                              style: TextStyle(
                                  color: _theme.textColor), // Texte en blanc
                              onSubmitted: (_) {
                                setState(() {
                                  isEmailInput = false;
                                });
                              },
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
                                height: 56, //
                                decoration: BoxDecoration(
                                  color: _theme.fieldFillColor,
                                  border: Border.all(
                                    color: Colors.green, // Bordure verte
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.email_outlined,
                                        color: Colors.white), // Icône email
                                    SizedBox(width: 10),
                                    Text(
                                      AppLocalizations.of(context).translate("sendOtpEmail"),
                                      style: TextStyle(
                                          color: _theme.textColor,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                      const SizedBox(height: 80),

                      buildActionButton(
                        text: AppLocalizations.of(context).translate("continueButton"),
                        backgroundColor: Color(0xFF29E33C),
                        textColor: const Color.fromARGB(255, 251, 251, 251),
                        onTap: () async {
                          if (isPhoneInput &&
                              phoneController.text.isNotEmpty &&
                              isTunisianNumber(phoneController.text)) {
                            con.forgotPassword(emailController.text);
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const OTPPage()),
                            // );
                          } else if (isPhoneInput &&
                              phoneController.text.isNotEmpty &&
                              !isTunisianNumber(phoneController.text)) {
                            // phone input rempli mais le numéro n'est pas vrai
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => const OTPPage()),
                            // );
                          } else if (isEmailInput &&
                              emailController.text.isNotEmpty &&
                              isEmail(emailController.text)) {
                            try {
                              Map<String, dynamic> response = await con
                                  .forgotPassword(emailController.text);

                              if (response.containsKey('resetToken') &&
                                  response.containsKey('code')) {
                                String resetToken = response['resetToken'];
                                int code = response['code'];

                                print("Email: ${emailController.text}");
                                print("ResetToken: $resetToken");
                                print("Code: $code");

                                await Navigator.of(context).pushReplacement(
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
                                    content: Text("${AppLocalizations.of(context).translate("connectionError")} : $e")),
                              );
                            }
                          }
                        },
                      ),

                      const SizedBox(height: 15),

                      buildActionButton(
                        text: AppLocalizations.of(context).translate("backToLogin"),
                        backgroundColor: Colors.transparent,
                        textColor: _theme.textColor, // Remplacement ici
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
