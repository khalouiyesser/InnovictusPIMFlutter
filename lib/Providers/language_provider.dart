import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String LANGUAGE_CODE = 'language_code';
  
  Locale _locale = const Locale('en');
  
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

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (_locale.languageCode == 'en') {
      _locale = const Locale('fr');
      await prefs.setString(LANGUAGE_CODE, 'fr');
    } else {
      _locale = const Locale('en');
      await prefs.setString(LANGUAGE_CODE, 'en');
    }
    notifyListeners();
  }
}