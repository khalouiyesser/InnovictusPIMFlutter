import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String LANGUAGE_CODE = 'language_code';

  Locale _locale = const Locale('en'); // Default language is English

  Locale get locale => _locale;

  bool get isEnglish => _locale.languageCode == 'en';

  Future<void> initializeLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString(LANGUAGE_CODE);
    if (langCode != null) {
      _locale = Locale(langCode);
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, newLocale.languageCode);
    _locale = newLocale;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}