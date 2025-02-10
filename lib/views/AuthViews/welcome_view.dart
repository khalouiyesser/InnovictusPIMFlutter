import 'package:flutter/material.dart';

import 'login_view.dart';



class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/welcome.png', // Change to your image path
              fit: BoxFit.cover, // Covers the full screen
            ),
          ),

          // Semi-transparent Dark Overlay
          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.5), // Adjust opacity for darkness
            ),
          ),

          // Centered Welcome Text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20), // Adjust horizontal padding
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Welcome to Green Energy  Chain",
                  textAlign: TextAlign
                      .center, // ✅ Ensures text is centered inside the container
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),

          // Button at the Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 50), // Adjust bottom spacing
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                  print("Button Pressed!");
                   // ✅ Navigate to LoginView
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );

                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor:
                      const Color.fromARGB(255, 37, 141, 51), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
