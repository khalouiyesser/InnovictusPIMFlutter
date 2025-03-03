import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:piminnovictus/Models/User.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/DashboardClient/Wallet.dart';
import 'package:piminnovictus/Views/DashboardClient/energy_settings_sheet.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:piminnovictus/viewmodels/WeatherAPI/bloc/weather_bloc_bloc.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:piminnovictus/Views/DashboardClient/profile_switcher_dropdown.dart';

import 'package:vector_math/vector_math_64.dart' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../Services/socket_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SessionManager _sessionManager = SessionManager();
  User? currentUser;

late WebSocketChannel channel;
  
  final SocketService _socketService = SocketService();



  int batteryLevel =0;
  double totalEnergy = 0.0;
  double capacity = 0.0;
  double co2Reduction = 0.0;
  double consumedEnergy=0.0;



  Widget getWeatherIcon(int code, {double size = 24.0}) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset(
          'assets/1.png',
          width: size,
          height: size,
        );
      case >= 300 && < 400:
        return Image.asset(
          'assets/2.png',
          width: size,
          height: size,
        );
      case >= 500 && < 600:
        return Image.asset(
          'assets/3.png',
          width: size,
          height: size,
        );
      case >= 600 && < 700:
        return Image.asset(
          'assets/4.png',
          width: size,
          height: size,
        );
      case >= 700 && < 800:
        return Image.asset(
          'assets/5.png',
          width: size,
          height: size,
        );
      case == 800:
        return Image.asset(
          'assets/6.png',
          width: size,
          height: size,
        );
      case > 800 && <= 804:
        return Image.asset(
          'assets/7.png',
          width: size,
          height: size,
        );
      default:
        return Image.asset(
          'assets/7.png',
          width: size,
          height: size,
        );
    }
  }

  // Déclaration de la variable _currentEnergyPercentage
  double _currentEnergyPercentage = 50.0; // Exemple de valeur initiale

  @override
  void initState() {
    super.initState();
    _loadUserData();


_socketService.connectToSocket((data) {
      if (mounted) {
        setState(() {
          totalEnergy = data['totalEnergy'] is num ? (data['totalEnergy'] as num).toDouble() : 0.0;
          capacity = data['capacity'] is num ? (data['capacity'] as num).toDouble() : 0.0;
          co2Reduction = data['co2Reduction'] is num ? (data['co2Reduction'] as num).toDouble() : 0.0;
          batteryLevel = data['batterylevel'] is int ? data['batterylevel'] : 0;
          consumedEnergy = data['consumed'] is num 
              ? double.parse((data['consumed'] as num).toStringAsFixed(2)) 
              : 0.0;
        });
      }
    });




  }

  Future<void> _loadUserData() async {
    final user = await _sessionManager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // On récupère le provider pour pouvoir l'utiliser si besoin
    final themeProvider = Provider.of<ThemeProvider>(context);
  final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;

    // Définir des couleurs pour le cercle de progression en fonction du thème
    final Color progressColor = theme.colorScheme.primary;
    // Vous pouvez choisir ici la couleur de fond pour le cercle (ici on utilise la teinte du hint ou un gris)
    final Color progressBackgroundColor = theme.hintColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            // Fond d'écran (background)
            BlurredRadialBackground(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Entête avec avatar, bienvenue et boutons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: screenWidth * 0.005,
                              ),
                            ),
                            child: Consumer<ProfileSwitcherViewModel>(
                              builder: (context, viewModel, child) {
                                if (viewModel.isLoading) {
                                  return SizedBox(
                                    width: screenWidth * 0.10,
                                    height: screenWidth * 0.10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 0,
                                      color: theme.colorScheme.primary,
                                    ),
                                  );
                                }

                                return ProfileSwitcherDropdown(
                                  customRadius: screenWidth * 0.06,
                                  borderColor: theme.colorScheme.primary,
                                  borderWidth: screenWidth * 0.006,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
  AppLocalizations.of(context).translate('welcomeBack'),
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontSize: screenWidth * 0.04),
                                ),
                                currentUser == null
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        currentUser!.name,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Row(
                            children: [],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Date
                      // Date et Localisation sur la même ligne
                      BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                        builder: (context, state) {
                          if (state is WeatherBlocSuccess) {
                                                              final translations = AppLocalizations.of(context);

                            return Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: padding),
                              child: Row(
                                children: [
                                  // Date
                                  Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(state.weather.date!),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: screenWidth * 0.035,
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                                  SizedBox(
                                      width: screenWidth *
                                          0.39), // Espacement entre la date et la localisation
                                  getWeatherIcon(
                                      state.weather.weatherConditionCode!,
                                      size: screenWidth * 0.07),

                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    '${state.weather.temperature!.celsius!.round()}°C',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: screenWidth * 0.035,
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),

                      SizedBox(height: screenHeight * 0.01),

// Température (Météo reste inchangée)
                      BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                        builder: (context, state) {
                          if (state is WeatherBlocSuccess) {

                            return Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: padding),
                              child: Row(
                                children: [
                                  // Localisation
                                  Text(
                                    '📍 ${state.weather.areaName}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: screenWidth * 0.035,
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Cercle de progression personnalisé
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size(screenWidth * 0.5, screenWidth * 0.5),
                              painter: CircularProgressPainter(
                                this.batteryLevel * 0.01,
                                progressColor: progressColor,
                                progressBackgroundColor:
                                    progressBackgroundColor,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                Text(
  AppLocalizations.of(context).translate('energyUsages'),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    color: theme.textTheme.titleMedium?.color
                                        ?.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  this.batteryLevel.toString()+"%",
                                  style:
                                      theme.textTheme.headlineLarge?.copyWith(
                                    fontSize: screenWidth * 0.1,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                Container(
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.primary,
                                      width: screenWidth * 0.01,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.bolt,
                                    color: theme.colorScheme.primary,
                                    size: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Grille d'infos
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        child: GridView.count(
                          childAspectRatio: 1.6,
                          crossAxisCount: screenWidth > 600 ? 4 : 2,
                          crossAxisSpacing: screenWidth * 0.04,
                          mainAxisSpacing: screenWidth * 0.04,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildInfoCard(context, AppLocalizations.of(context).translate('totalEnergy'), '${this.totalEnergy} ${AppLocalizations.of(context).translate('kwh')}',
                                Icons.lightbulb),
                            _buildInfoCard(
  context, 
  AppLocalizations.of(context).translate('consumed'), 
  '${this.consumedEnergy} ${AppLocalizations.of(context).translate('kwh')}',
  Icons.flash_on
),
                            _buildInfoCard(context,  AppLocalizations.of(context).translate('capacity'), 
  '42.0 ${AppLocalizations.of(context).translate('kwh')}',
                                Icons.battery_full),
                            _buildInfoCard(context,  AppLocalizations.of(context).translate('co2Reduction'), 
  '${this.co2Reduction} ${AppLocalizations.of(context).translate('kwh')}',
                                Icons.eco),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Graphique d'électricité
                      _buildElectricityChart(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bouton image pour accéder à WalletPage ou afficher EnergySettingsSheet en pop-up
  Widget _buildImageButton(
      String assetPath, double width, double height, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }

  // Carte d'information personnalisée
  Widget _buildInfoCard(
      BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.70),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.11) ??
              const Color.fromRGBO(41, 227, 60, 1).withOpacity(0.11),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary ?? MyThemes.primaryColor,
            size: 23,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Graphique d'électricité avec le package fl_chart
  Widget _buildElectricityChart(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        color: theme.cardColor.withOpacity(0.90),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.1) // Mode sombre
                : const Color(0xFFDDECE3).withOpacity(0.7), // Mode clair
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.11) ??
                  MyThemes.primaryColor.withOpacity(0.11),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
  AppLocalizations.of(context).translate('electricityGenerated'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "140.65 kWh",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 5,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            if (value % 50 == 0 && value <= 200) {
                              return Text(
                                '${value.toInt()} kWh',
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color ??
                                      Colors.white,
                                  fontSize: 10,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            const labels = [
                              "13:00",
                              "14:00",
                              "15:00",
                              "16:00",
                              "17:00",
                              "18:00"
                            ];
                            int index = value.toInt();
                            if (index >= 0 && index < labels.length) {
                              return Text(
                                labels[index],
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color ??
                                      Colors.white,
                                  fontSize: 9,
                                  height: 3,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 0),
                          FlSpot(1, 150),
                          FlSpot(2, 100),
                          FlSpot(3, 50),
                          FlSpot(4, 200),
                          FlSpot(5, 150),
                        ],
                        isCurved: true,
                        color:
                            theme.colorScheme.primary ?? MyThemes.primaryColor,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: (theme.colorScheme.primary ??
                                  MyThemes.primaryColor)
                              .withOpacity(0.11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------
// Custom Painter pour le cercle de progression
//---------------------------------------------------------------------
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color progressBackgroundColor;

  CircularProgressPainter(
    this.progress, {
    required this.progressColor,
    required this.progressBackgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = progressBackgroundColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [progressColor, Colors.white70],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 7;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.radians(135),
      math.radians(270),
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.radians(135),
      math.radians(270 * progress),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
