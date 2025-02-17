import 'package:flutter/material.dart';


class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/Pulse.png",
              fit: BoxFit.cover,
            ),
          ),
          // Overlay
          Scaffold(
            extendBodyBehindAppBar: true, // This allows the body to extend behind the AppBar
            appBar: AppBar(
              title: const Text('Terms & Conditions'),
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0, // Remove AppBar shadow
              flexibleSpace: Container( // Add background to AppBar
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body:
            Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Terms and Conditions",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(
                                color: Color.fromARGB(90, 255, 255, 255),
                                thickness: 2,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Welcome to GreenEnergyChain, a blockchain-based platform dedicated to the management and trading of renewable energy. By accessing or using our platform, you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully before using our services.\n\n"
                                    "1. Acceptance of Terms\n"
                                    "By using GreenEnergyChain, you agree to these Terms and Conditions, our Privacy Policy, and all applicable laws and regulations in Tunisia. If you do not agree with any part of these terms, you must not use our platform.\n\n"
                                    "2. Description of Services\n"
                                    "GreenEnergyChain provides a decentralized marketplace for the trading of renewable energy using blockchain technology.\n\n"
                                    "3. User Accounts\n"
                                    "- Registration: To use our services, you must create an account.\n"
                                    "- Security: You are responsible for maintaining account security.\n"
                                    "- Eligibility: You must be at least 18 years old.\n\n"
                                    "4. Privacy and Data Security\n"
                                    "Your privacy is important to us. Please refer to our Privacy Policy.\n\n"
                                    "5. Contact Information\n"
                                    "For questions or concerns, please contact support@greenenergychain.com",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 31, 219, 59),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              "I Understand",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ),]);
  }
}