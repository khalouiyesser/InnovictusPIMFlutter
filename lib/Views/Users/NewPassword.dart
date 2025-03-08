import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/Views/DashboardClient/ConnectWallet.dart';
import 'dart:ui';
import 'package:piminnovictus/Views/bachground.dart';

class NewPasswordPage extends StatefulWidget {
  final String resetToken;

  const NewPasswordPage({super.key, required this.resetToken});

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage>
    with WidgetsBindingObserver {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final AuthController authController = AuthController();
  late AuthScreenTheme _theme;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTheme();
    // S'enregistre pour écouter les changements de luminosité du système
    WidgetsBinding.instance.addObserver(this);
    print("Reset Token reçu : ${widget.resetToken}");
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
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _validateAndSubmit() async {
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Vérification si les mots de passe sont identiques
    if (password != confirmPassword) {
      _showErrorDialog(
          AppLocalizations.of(context).translate("passwordsDoNotMatch"));
      return;
    }

    // Vérification de la longueur du mot de passe
    if (password.length < 6) {
      _showErrorDialog(
          AppLocalizations.of(context).translate("passwordTooShort"));
      return;
    }

    // Vérification si le mot de passe contient au moins un chiffre
    if (!RegExp(r'^(?=.*[0-9])').hasMatch(password)) {
      _showErrorDialog(
          AppLocalizations.of(context).translate("passwordRequireNumber"));
      return;
    }

    // Afficher l'indicateur de chargement
    setState(() {
      _isLoading = true;
    });

    // Si tout est valide, appeler la méthode pour réinitialiser le mot de passe
    authController.resetPassword(widget.resetToken, password);

    // Attendre 5 secondes avant de naviguer vers la page de connexion
    await Future.delayed(const Duration(seconds: 5));

    // Masquer l'indicateur de chargement (bien que nous allons naviguer ailleurs)
    setState(() {
      _isLoading = false;
    });

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
    );
    print("Password reset request sent!");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate("error")),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).translate("ok")),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  AppLocalizations.of(context).translate("enterNewPassword"),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _theme.textColor,
                  ),
                ),
                const SizedBox(height: 80),

                // Password Field
                _buildPasswordField(
                    AppLocalizations.of(context).translate("password"),
                    passwordController,
                    _obscurePassword, () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                }),

                const SizedBox(height: 15),

                // Confirm Password Field
                _buildPasswordField(
                    AppLocalizations.of(context).translate("confirmPassword"),
                    confirmPasswordController,
                    _obscureConfirmPassword, () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                }),

                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF29E33C), // ✅ Couleur verte (29E33C)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate("save"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Overlay pour l'indicateur de chargement plein écran
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF29E33C)),
                        strokeWidth: 5,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context).translate("processing"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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

  Widget _buildPasswordField(String hint, TextEditingController controller,
      bool obscureText, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: _theme.textColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: _theme.fieldFillColor,
        hintText: hint,
        hintStyle: TextStyle(
          color: AuthScreenThemeDetector.isSystemDarkMode()
              ? _theme.hintTextColor
              : Colors.black54,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: _theme.textColor,
          ),
          onPressed: toggleVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Color(0xFF29E33C), width: 1), // ✅ Bordure verte (29E33C)
        ),
      ),
    );
  }
}
