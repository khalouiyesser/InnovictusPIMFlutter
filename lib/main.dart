
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Views/DashboardClient/ConnectWallet.dart';
import 'package:piminnovictus/Views/DashboardClient/Dashboard.dart';
import 'package:piminnovictus/viewmodels/WalletViewModel.dart';
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
          ChangeNotifierProvider(create: (_) => WalletViewModel()),
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
          
          //ajbouni
          //home: BottomNavBarExample(),
        );
      },
    );
  }
}











