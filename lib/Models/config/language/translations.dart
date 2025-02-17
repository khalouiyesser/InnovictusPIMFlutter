import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome',
      'settings': 'Settings',
      'home': 'Home',
      'profile': 'Profile',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'preferences': 'Preferences',
    'logout': 'Logout',
      // Add more translations here
    },
    'fr': {
      'welcome': 'Bienvenue',
      'settings': 'Paramètres',
      'home': 'Accueil',
      'profile': 'Profil',
      'language': 'Langue',
      'darkMode': 'Mode Sombre',
      'preferences': 'Préférences',
    'logout': 'Déconnexion',
      // Add more translations here
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? 
           key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}