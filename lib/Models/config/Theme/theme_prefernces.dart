import 'package:piminnovictus/Models/config/Theme/theme_prefernces.dart';

class DarkThemePreference {
  static const String _key = "isDarkTheme";

  /// Enregistre la préférence pour le thème sombre
  static Future<void> setDarkTheme(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, value);
    } catch (e) {
      print("Erreur en enregistrant le thème : $e");
    }
  }

  /// Récupère la préférence pour le thème sombre
  static Future<bool> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_key) ?? false;
    } catch (e) {
      print("Erreur en récupérant le thème : $e");
      return false;
    }
  }
}

class SharedPreferences {
  static getInstance() {}

  setBool(String key, bool isDarkMode) {}

  getBool(String key) {}
}
