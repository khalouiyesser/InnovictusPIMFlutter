import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    // Profile Section
    'profileInformation': 'Profile Information',
    'personalInformation': 'Personal Information',
    'username': 'Username',
    'email': 'Email',
    'phone': 'Phone',
    'password': 'Password',
    'currentPassword': 'Current Password',
    'newPassword': 'New Password',
    'confirmPassword': 'Confirm Password',
    
    // Preferences Section
    'preferences': 'Preferences',
    'darkMode': 'Dark Mode',
    'language': 'Language',
    'english': 'English',
    'french': 'French',
    
    // Terms & Privacy Section
    'termsAndPrivacy': 'Terms & Privacy',
    'termsAndConditions': 'Terms & Conditions',
    'privacyPolicy': 'Privacy Policy',
    
    // Actions & Buttons
    'save': 'Save',
    'logout': 'Logout',
  },
  'fr': {
    // Profile Section
    'profileInformation': 'Informations du Profil',
    'personalInformation': 'Informations Personnelles',
    'username': 'Nom d\'utilisateur',
    'email': 'E-mail',
    'phone': 'Téléphone',
    'password': 'Mot de passe',
    'currentPassword': 'Mot de passe actuel',
    'newPassword': 'Nouveau mot de passe',
    'confirmPassword': 'Confirmer le mot de passe',
    
    // Preferences Section
    'preferences': 'Préférences',
    'darkMode': 'Mode Sombre',
    'language': 'Langue',
    'english': 'Anglais',
    'french': 'Français',
    
    // Terms & Privacy Section
    'termsAndPrivacy': 'Conditions et Confidentialité',
    'termsAndConditions': 'Conditions Générales',
    'privacyPolicy': 'Politique de Confidentialité',
    
    // Actions & Buttons
    'save': 'Enregistrer',
    'logout': 'Déconnexion',
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