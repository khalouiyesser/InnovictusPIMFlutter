import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String key = "isDarkMode";

  Future<void> setTheme(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, isDarkMode);
  }

  Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}

