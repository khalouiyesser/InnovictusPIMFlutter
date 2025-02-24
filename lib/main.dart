/*import 'package:firebase_core/firebase_core.dart';
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

  Position position = await _determinePosition();
   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        BlocProvider(
          create: (context) => WeatherBlocBloc()..add(FetchWeather(position)),
        ),
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
      builder: (context, themeProvider, languageProvider, _) {
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
          home: Builder(
            builder: (context) => FutureBuilder<Position>(
              future: _determinePosition(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Directionality(
                    textDirection: TextDirection.ltr,
                    child: Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Scaffold(
                      body: Center(
                        child: Text('Erreur: ${snapshot.error}'),
                      ),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  return BlocProvider(
                    create: (context) => WeatherBlocBloc()
                      ..add(FetchWeather(snapshot.data as Position)),
                    child: WelcomePage(),
                  );
                }

                return const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Scaffold(
                    body: Center(
                      child: Text('État inattendu'),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  try {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Les services de localisation sont désactivés.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Les permissions de localisation ont été refusées';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Les permissions de localisation sont définitivement refusées';
    }

    return await Geolocator.getCurrentPosition();
  } catch (e) {
    throw 'Erreur de localisation: $e';
  }
}
*/

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
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  try {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Les services de localisation sont désactivés.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Les permissions de localisation ont été refusées';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Les permissions de localisation sont définitivement refusées';
    }

    return await Geolocator.getCurrentPosition();
  } catch (e) {
    throw 'Erreur de localisation: $e';
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final themeProvider = ThemeProvider();
    final languageProvider = LanguageProvider();
    final sessionManager = SessionManager();
    final isLoggedIn = await sessionManager.isLoggedIn();

    await Future.wait([
      themeProvider.init(),
      languageProvider.initializeLocale(),
    ]);

    Position position = await _determinePosition();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider.value(value: languageProvider),
          ChangeNotifierProvider(
              create: (_) => ProfileSwitcherViewModel()..loadProfiles()),
          BlocProvider(
            create: (context) => WeatherBlocBloc()..add(FetchWeather(position)),
          ),
        ],
        child: MyApp(isLoggedIn: isLoggedIn),
      ),
    );
  } catch (e) {
    print('Erreur lors de l\'initialisation de l\'application: $e');
    // Vous pourriez ici afficher un widget d'erreur ou gérer l'erreur différemment
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PIM Innovictus',
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
          home: isLoggedIn ? BottomNavBarExample() : WelcomePage(),
        );
      },
    );
  }
}




















/*void main() async {
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
