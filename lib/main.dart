import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/views/AuthViews/welcome_view.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp();

  // // Initialisation de Stripe
  // Stripe.publishableKey = "pk_test_51QrpAmR8fzucGsmZnxLGc6kT7BSr3uYxzaSiG7xLNF8GcchuhI6MUsX7k1ipqf1c1vQjHtSDYhsE9Ey1jclk4C7E00vmFxgkaz"; // Remplace par ta clé Publishable Stripe
  // Stripe.instance.applySettings(); // Assure l'initialisation du SDK Stripe

  // Initialisation de ThemeProvider
  final themeProvider = ThemeProvider();
  final languageProvider = LanguageProvider();

  await Future.wait([
    themeProvider.init(),
    languageProvider.initializeLocale(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('fr', ''),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),

          ],
          home: WelcomePage(),
        );
      },
    );
  }
}
