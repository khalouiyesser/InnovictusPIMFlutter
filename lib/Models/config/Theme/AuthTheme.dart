import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Classe utilitaire pour détecter le thème système dans les écrans de login/signup
class AuthScreenThemeDetector {
  // Détecte si le thème système est en mode sombre
  static bool isSystemDarkMode() {
    final brightness = SchedulerBinding.instance.window.platformBrightness;
    return brightness == Brightness.dark;
  }

  // Retourne les couleurs et styles appropriés selon le thème système
  static AuthScreenTheme getTheme() {
    final isDarkMode = isSystemDarkMode();

    return AuthScreenTheme(
      textColor: isDarkMode ? Colors.white : Colors.black,
      backgroundColor: isDarkMode ? const Color(0xFF151F1A) : Colors.white,
      backgroundGradientColors: isDarkMode
          ? [
              const Color(0xFF93DAB2).withOpacity(0.9),
              Colors.white.withOpacity(0.8)
            ]
          : [
              const Color(0xFF93DAB2).withOpacity(0.8),
              Colors.white.withOpacity(0.8)
            ],
      fieldFillColor: isDarkMode
          ? Colors.white.withOpacity(0.2)
          : Colors.grey.withOpacity(0.1),
      hintTextColor: isDarkMode ? Colors.white70 : Colors.black54,
      primaryColor: const Color(0xFF29E33C),
      shouldShowBackgroundImage: isDarkMode,
    );
  }
}

// Classe pour stocker les couleurs et styles des écrans d'authentification
class AuthScreenTheme {
  final Color textColor;
  final Color backgroundColor;
  final List<Color> backgroundGradientColors;
  final Color fieldFillColor;
  final Color hintTextColor;
  final Color primaryColor;
  final bool shouldShowBackgroundImage;

  AuthScreenTheme({
    required this.textColor,
    required this.backgroundColor,
    required this.backgroundGradientColors,
    required this.fieldFillColor,
    required this.hintTextColor,
    required this.primaryColor,
    required this.shouldShowBackgroundImage,
  });
}
