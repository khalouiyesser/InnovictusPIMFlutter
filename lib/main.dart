import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Add this import
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/Views/DashboardClient/Wallet.dart';
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/views/AuthViews/welcome_view.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase 
   await Firebase.initializeApp();

  // Initialize ThemeProvider and LanguageProvider
  final themeProvider = ThemeProvider();
  final languageProvider = LanguageProvider();
  final sessionManager = SessionManager();
    final isLoggedIn = await sessionManager.isLoggedIn();


  await Future.wait([
    themeProvider.init(),
    languageProvider.initializeLocale(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider(create: (_) => ProfileSwitcherViewModel()..loadProfiles()),

      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
    final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: languageProvider.locale, // Set the locale from LanguageProvider
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('fr', ''), // French
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(), // Your custom delegate
            GlobalMaterialLocalizations.delegate, // Material localizations
            GlobalWidgetsLocalizations.delegate, // Widgets localizations
            GlobalCupertinoLocalizations.delegate, // Cupertino localizations
          ],
          home: isLoggedIn ? BottomNavBarExample() : WelcomePage(),
        );
      },
    );
  }
}