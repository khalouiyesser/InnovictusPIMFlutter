import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettings {
  static final LanguageSettings _instance = LanguageSettings._internal();
  
  factory LanguageSettings() {
    return _instance;
  }

  LanguageSettings._internal();

  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  set locale(Locale newLocale) {
    _locale = newLocale;
    _saveLocale(newLocale.languageCode);
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale_lang');
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
  }

  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_lang', languageCode);
  }
}