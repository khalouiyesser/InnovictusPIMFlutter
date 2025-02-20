import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Views/DashboardClient/Dashboard.dart';
import 'package:piminnovictus/viewmodels/WeatherAPI/bloc/weather_bloc_bloc.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/views/AuthViews/welcome_view.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _determinePosition(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // On enveloppe l'application entière dans un BlocProvider
          return BlocProvider<WeatherBlocBloc>(
            create: (context) =>
                WeatherBlocBloc()..add(FetchWeather(snapshot.data as Position)),
            child: Consumer2<ThemeProvider, LanguageProvider>(
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
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  // La première page est WelcomePage ou Dashboard selon ta navigation
                  home: WelcomePage(),
                );
              },
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  return await Geolocator.getCurrentPosition();
}







/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize ThemeProvider and LanguageProvider
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
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: FutureBuilder<Position>(
            future: _determinePosition(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BlocProvider(
                  create: (context) => WeatherBlocBloc()
                    ..add(FetchWeather(snapshot.data as Position)),
                  child: WelcomePage(),
                );
              }
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  return await Geolocator.getCurrentPosition();
}
*/
