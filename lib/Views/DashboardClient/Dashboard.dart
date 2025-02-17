/*import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Views/DashboardClient/buyEnergie.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Récupération du thème actif
    final themeProvider = Provider.of<ThemeProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double padding = screenWidth * 0.04; // Proportionnel à la largeur

    return Scaffold(
      //backgroundColor: const Color(0xFF0A140C),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            BlurredRadialBackground(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF29E33C),
                                width: screenWidth * 0.008,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: screenWidth * 0.06,
                              backgroundImage: AssetImage('assets/user.jpg'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back!',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text('Khaled Guedria',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _buildImageButton(
                                  "assets/wallet.png",
                                  screenWidth * 0.09,
                                  screenWidth * 0.09,
                                  context),
                              SizedBox(width: screenWidth * 0.04),
                              Stack(
                                children: [
                                  _buildImageButton(
                                      "assets/settings.png",
                                      screenWidth * 0.08,
                                      screenWidth * 0.08,
                                      context),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: screenWidth * 0.03,
                                      height: screenWidth * 0.03,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('10 Février, 2025',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: screenWidth * 0.035,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wb_sunny,
                              color: Colors.yellow,
                              size: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text('23°C',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: screenWidth * 0.035,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size(screenWidth * 0.5, screenWidth * 0.5),
                              painter: CircularProgressPainter(0.85),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                const Text('Energy Usages',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 16)),
                                const SizedBox(height: 1),
                                Text('85%',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.1,
                                        fontWeight: FontWeight.normal)),
                                SizedBox(height: screenHeight * 0.03),
                                Container(
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.green,
                                        width: screenWidth * 0.01),
                                  ),
                                  child: Icon(Icons.bolt,
                                      color: Colors.green,
                                      size: screenWidth * 0.05),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        child: GridView.count(
                          childAspectRatio:
                              1.6, // Adjust the aspect ratio as needed
                          crossAxisCount: screenWidth > 600
                              ? 4
                              : 2, // More columns for wider screens
                          crossAxisSpacing: screenWidth * 0.04,
                          mainAxisSpacing: screenWidth * 0.04,
                          shrinkWrap:
                              true, // Permet au GridView de s'ajuster à son contenu
                          physics:
                              const NeverScrollableScrollPhysics(), // Désactive le défilement interne du GridView
                          children: [
                            _buildInfoCard(
                                'Total Energy', '36.2 Kwh', Icons.lightbulb),
                            _buildInfoCard(
                                'Consumed', '28.2 Kwh', Icons.flash_on),
                            _buildInfoCard(
                                'Capacity', '42.0 Kwh', Icons.battery_full),
                            _buildInfoCard(
                                'CO2 Reduction', '28.2 Kwh', Icons.eco),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      _buildElectricityChart(),
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

  Widget _buildImageButton(
      String assetPath, double width, double height, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (assetPath == "assets/settings.png") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuyEnergiePage()),
          );
        }
      },
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

Widget _buildIconButton(IconData icon, double screenWidth) {
  return Container(
    width: screenWidth * 0.1,
    height: screenWidth * 0.1,
    padding: EdgeInsets.all(screenWidth * 0.02),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.5),
      shape: BoxShape.circle,
    ),
    child: Icon(
      icon,
      color: Colors.white,
      size: 26,
    ),
  );
}

Widget _buildInfoCard(String title, String value, IconData icon) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 26, 39, 33).withOpacity(0.70),
      border: Border.all(
        color: const Color(0xFF29E33C).withOpacity(0.11),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF29E33C), size: 23),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _buildElectricityChart() {
  return Center(
    child: Card(
      color: Color.fromARGB(255, 26, 39, 33).withOpacity(0.90),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          border: Border.all(
            color: const Color(0xFF29E33C).withOpacity(0.11),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Electricity Generated by Solar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Ajout du texte affichant la valeur totale
            const Text(
              "140.65 kWh",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200, // Hauteur ajustée pour le graphique
              child: LineChart(
                LineChartData(
                  minX: 0, // Définir les bornes de l'axe X
                  maxX: 5, // Dernier point

                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          if (value % 50 == 0 && value <= 200) {
                            return Text(
                              '${value.toInt()} kWh',
                              style: const TextStyle(
                                color: Colors.white,
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
                        interval: 1, // Assure un espacement correct

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
                              style: const TextStyle(
                                color: Colors.white,
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
                      spots: [
                        FlSpot(0, 0),
                        FlSpot(1, 150),
                        FlSpot(2, 100),
                        FlSpot(3, 50),
                        FlSpot(4, 200),
                        FlSpot(5, 150),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                          show: false), //ken nheb ndhaher poinet nactivi hedhy
                      belowBarData: BarAreaData(
                        show:
                            true, //ken nheb nahy dhaw li tahet diagr ndesactivi hedhy
                        color: Colors.green.withOpacity(0.11),
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

class CircularProgressPainter extends CustomPainter {
  final double progress;
  CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF29E33C), Colors.white70],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 7;

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
}*/

import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Views/DashboardClient/Wallet.dart';
import 'package:piminnovictus/Views/DashboardClient/buyEnergie.dart';
import 'package:piminnovictus/Views/DashboardClient/energy_settings_sheet.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Déclaration de la variable _currentEnergyPercentage
  double _currentEnergyPercentage = 50.0; // Exemple de valeur initiale

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // On récupère le provider pour pouvoir l'utiliser si besoin
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                                width: screenWidth * 0.008,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: screenWidth * 0.06,
                              backgroundImage:
                                  const AssetImage('assets/user.jpg'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back!',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontSize: screenWidth * 0.04),
                                ),
                                Text(
                                  'Khaled Guedria',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _buildImageButton(
                                  "assets/wallet.png",
                                  screenWidth * 0.09,
                                  screenWidth * 0.09,
                                  context),
                              SizedBox(width: screenWidth * 0.04),
                              Stack(
                                children: [
                                  _buildImageButton(
                                      "assets/settings.png",
                                      screenWidth * 0.08,
                                      screenWidth * 0.08,
                                      context),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: screenWidth * 0.03,
                                      height: screenWidth * 0.03,
                                      decoration: const BoxDecoration(
                                        color: Colors
                                            .red, // Vous pouvez le thématiser
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Date
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Row(
                          children: [
                            Text(
                              '10 Février, 2025',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: screenWidth * 0.035,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      // Température
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wb_sunny,
                              color: Colors.yellow,
                              size: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              '23°C',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: screenWidth * 0.035,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
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
                                0.85,
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
                                  'Energy Usages',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    color: theme.textTheme.titleMedium?.color
                                        ?.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  '85%',
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
                            _buildInfoCard(context, 'Total Energy', '36.2 Kwh',
                                Icons.lightbulb),
                            _buildInfoCard(context, 'Consumed', '28.2 Kwh',
                                Icons.flash_on),
                            _buildInfoCard(context, 'Capacity', '42.0 Kwh',
                                Icons.battery_full),
                            _buildInfoCard(context, 'CO2 Reduction', '28.2 Kwh',
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
      onTap: () {
        if (assetPath == "assets/settings.png") {
          // Ouvrir EnergySettingsSheet en pop-up
          EnergySettingsSheet.show(
            context,
            initialPercentage: _currentEnergyPercentage,
            onSave: (newPercentage) {
              setState(() {
                _currentEnergyPercentage = newPercentage;
              });
            },
          );
        } else if (assetPath == "assets/wallet.png") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WalletPage()),
          );
        }
      },
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
              MyThemes.primaryColor.withOpacity(0.11),
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
                "Electricity Generated by Solar",
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