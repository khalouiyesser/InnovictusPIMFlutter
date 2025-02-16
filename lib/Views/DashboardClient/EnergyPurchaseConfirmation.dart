import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/Views/DashboardClient/Dashboard.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';

class EnergyPurchaseConfirmationPage extends StatelessWidget {
  final double energyAmount;

  EnergyPurchaseConfirmationPage({required this.energyAmount});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final theme = themeProvider.currentTheme ??
        ThemeData
            .light(); // Ajouter une valeur par défaut au cas où le thème est null

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            BlurredRadialBackground(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF29E33C)
                              .withOpacity(0.3), // Couleur de l'ombre
                          blurRadius: 10, // Flou de l'ombre
                          spreadRadius: 2, // Expansion de l'ombre
                          offset: Offset(0, 5), // Décalage de l'ombre
                        ),
                      ],
                    ),
                    child: Icon(Icons.check_circle,
                        color: Color(0xFF29E33C), size: 100),
                  ),
                  SizedBox(height: 80),
                  Text(
                    'Purchase Successful',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontSize: screenWidth * 0.05),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You have purchased $energyAmount kWh of solar energy.",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontSize: screenWidth * 0.04),
                  ),
                  const SizedBox(height: 30),
                  const LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your energy is being generated...',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontSize: screenWidth * 0.04),
                  ),
                  SizedBox(height: 30),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BottomNavBarExample()), // Navigue vers Dashboard
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF29E33C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
