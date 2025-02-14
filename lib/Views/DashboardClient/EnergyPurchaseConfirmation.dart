import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/Views/DashboardClient/Dashboard.dart';

class EnergyPurchaseConfirmationPage extends StatelessWidget {
  final double energyAmount;

  EnergyPurchaseConfirmationPage({required this.energyAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A140C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                          .withOpacity(0.5), // Couleur de l'ombre
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
              const Text(
                "Purchase Successful!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "You have purchased $energyAmount kWh of solar energy.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 20),
              const Text(
                "Your energy is being delivered...",
                style: TextStyle(color: Colors.white54, fontSize: 17),
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
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
      ),
    );
  }
}
