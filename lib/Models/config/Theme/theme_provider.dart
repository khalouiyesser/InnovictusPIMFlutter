/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String key = "isDarkTheme";
  late SharedPreferences _prefs;
  late bool _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider({required SharedPreferences prefs}) {
    _prefs = prefs;
    _isDarkMode = _prefs.getBool(key) ?? true; // Charge la préférence
  }

  Future<void> toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    await _prefs.setBool(key, _isDarkMode);
    notifyListeners();
  }
}

class MyThemes {
  // Définition des couleurs principales
  static const Color primaryColor = Color(0xFF29E33C);
  static const Color secondaryColor = Color(0xFF151F1A);
  static const Color blackColor = Color(0xFF151F1A);
  static const Color greyColor = Color(0xFFF9F9F9);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static const Color primaryColorLight = Color(0xFF93DAB2); // Linear
  static const Color cardColor = Color(0xFFDDECE3); // Cartes
  static const Color greenText = Color(0xFF29E33C); // Écriture verte
  static const Color blackText = Color(0xFF151F1A); // Écriture noire
  static const Color whiteColorlight = Color(0xFFFFFFFF);

  // Thème clair
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColorLight: primaryColorLight,
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: const AppBarTheme(
      color: primaryColorLight,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(color: blackText, fontSize: 18),
    ),
    iconTheme: const IconThemeData(color: blackColor),
    colorScheme: const ColorScheme.light(
      tertiary: cardColor,
      secondary: whiteColorlight,
      primary: primaryColorLight,
      onPrimary: primaryColorLight,
      surface: greyColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
    ),
  );

  // Thème sombre
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: secondaryColor,
    scaffoldBackgroundColor: secondaryColor,
    appBarTheme: const AppBarTheme(
      color: secondaryColor,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(color: whiteColorlight, fontSize: 18),
    ),
    iconTheme: const IconThemeData(color: whiteColor),
    colorScheme: const ColorScheme.dark(
      tertiary: secondaryColor,
      secondary: primaryColor,
      primary: primaryColor,
      onPrimary: whiteColor,
      surface: Color(0xFF151F1A),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
    ),
  );
}*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String key =
      "isDarkMode"; // Utilisation d'une clé unique pour la préférence
  late SharedPreferences _prefs;
  bool _isDarkMode = true; // Valeur par défaut

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;

  //get currentTheme => null;
  ThemeData get currentTheme => _isDarkMode
      ? MyThemes.darkTheme
      : MyThemes.lightTheme; // ✅ Retourne le bon thème

  // Future pour attendre l'initialisation des SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(key) ??
        true; // Charge la préférence, valeur par défaut : true (mode sombre)
    notifyListeners();
  }

  // Fonction pour basculer le thème
  Future<void> toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    await _prefs.setBool(key, _isDarkMode); // Sauvegarde la préférence
    notifyListeners();
  }
}

class MyThemes {
  // 🎨 Définition des couleurs principales
  static const Color primaryColor = Color(0xFF29E33C);
  static const Color secondaryColor = Color(0xFF151F1A);
  static const Color blackColor = Color(0xFF151F1A);
  static const Color greyColor = Color(0xFFF9F9F9);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static const Color primaryColorLight = Color(0xFF29E33C); // Linear
  static const Color cardColor = Color(0xFFDDECE3); // Cartes
  static const Color greenText = Color(0xFF29E33C); // Écriture verte
  static const Color blackText = Color(0xFF151F1A); // Écriture noire
  static const Color whiteColorlight = Color(0xFFFFFFFF);

  // 🌞 Thème clair
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: const AppBarTheme(
      color: primaryColorLight,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(color: blackText, fontSize: 18),
    ),
    iconTheme: const IconThemeData(color: blackColor),
    //iconTheme: const IconThemeData(color: primaryColor), // ✅ Icônes en vert

    cardColor: cardColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColorLight,
      secondary: whiteColorlight,
      surface: greyColor,
      onPrimary: blackText,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
    ),
    useMaterial3: true, // Important si tu utilises Material 3
  );

  // 🌑 Thème sombre
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: secondaryColor,
    scaffoldBackgroundColor: secondaryColor,
    appBarTheme: const AppBarTheme(
      color: secondaryColor,
      iconTheme: IconThemeData(color: primaryColor),
      titleTextStyle: TextStyle(color: whiteColorlight, fontSize: 18),
    ),
    iconTheme: const IconThemeData(color: whiteColor),
    cardColor: secondaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
      surface: Color(0xFF151F1A),
      //onPrimary: whiteColor,
      onPrimary: whiteColor, // ✅ Texte blanc dans le mode sombre
      onSurface: whiteColor, // ✅ Texte blanc sur les surfaces sombres
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: whiteColor), // ✅ Texte des titres en blanc
      bodyLarge: TextStyle(color: whiteColor), // ✅ Texte normal en blanc
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
    ),
    useMaterial3: true, // Important si tu utilises Material 3
  );
}