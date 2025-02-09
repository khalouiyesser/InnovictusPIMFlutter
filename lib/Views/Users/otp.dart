import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:piminnovictus/Views/bachground.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  List<String> otpCode = List.filled(6, ""); // Liste pour stocker le code OTP
  late List<FocusNode>
      focusNodes; // Liste des FocusNodes pour gérer la navigation entre les champs

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredRadialBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Align(
                  alignment: Alignment.centerLeft, // Aligner le texte à gauche
                  child: Text(
                    "Enter OTP Code",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 70),
                // OTP Code Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50,
                      height: 50,
                      child: TextField(
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLength: 1,
                        buildCounter: (context,
                                {required currentLength,
                                required isFocused,
                                required maxLength}) =>
                            null,
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context)
                                .requestFocus(focusNodes[index + 1]);
                          }
                          otpCode[index] = value;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Send Code Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String otp = otpCode.join();
                      print("OTP entré : $otp");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "SENT CODE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "You have not received the code ?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                  },
                  child: const Text(
                    "Resend",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
