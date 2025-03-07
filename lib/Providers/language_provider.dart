import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String LANGUAGE_CODE = 'language_code';
  static const String SYS_LANG_FOR_AUTH = 'system_language_for_auth';

  Locale _locale = const Locale('en'); // Default language is English
  bool _useSystemForAuth = true; 
  Locale get locale => _locale;

  bool get isEnglish => _locale.languageCode == 'en';
  bool get useSystemForAuth => _useSystemForAuth;

 Locale getLocaleForInterface(bool isAuthScreen) {
    if (isAuthScreen && _useSystemForAuth) {
      // Pour les écrans d'authentification, utiliser la langue du système si activé
      return Locale(WidgetsBinding.instance.window.locale.languageCode);
    } else {
      // Pour les autres écrans, utiliser la langue choisie par l'utilisateur
      return _locale;
    }
  }

  Future<void> initializeLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString(LANGUAGE_CODE);
        _useSystemForAuth = prefs.getBool(SYS_LANG_FOR_AUTH) ?? true;

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
   Future<void> setUseSystemForAuth(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SYS_LANG_FOR_AUTH, value);
    _useSystemForAuth = value;
    notifyListeners();
  }
}