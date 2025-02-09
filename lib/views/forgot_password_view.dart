// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class ForgotPasswordView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: [
//           // Background Gradient
//           Positioned.fill(
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                //     Color(0xFF155615), // Vert foncé
//                  //   Color(0xFF0D480D), // Vert intermédiaire
//                     Color(0xFF0A3F0A), // Vert encore plus foncé
//                     Color(0xFF032203), // Vert très foncé
//                     Colors.black
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),
//           // Exemple de texte pour voir l'écran
//           const Center(
//             child: Text(
//               'Forgot Password',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';


class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Dégradé de fond
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFA011001), // Vert foncé en haut
                    Color(0xFA011001), // Fond identique en bas
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Ellipse verte au centre
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF011E01), // Vert intermédiaire
                shape: BoxShape.circle, // Forme elliptique
              ),
            ),
          ),

          // Contenu principal avec padding
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40), // Espacement supérieur

                  // Titre "Forgot Password?"
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40), // Espacement

                  // Boutons d'OTP
                  buildOptionButton(Icons.chat_bubble_outline, "Send OTP via SMS"),
                  const SizedBox(height: 15),
                  buildOptionButton(Icons.email_outlined, "Send OTP via Email"),
                  const SizedBox(height: 30),

                  // Bouton "Continue"
                  buildActionButton("Continue", Colors.green, Colors.white),

                  const SizedBox(height: 15),

                  // Bouton "Back to Login"
                  buildActionButton("Back To Login", Colors.transparent, Colors.green, Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionButton(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(String text, Color backgroundColor, Color textColor, [Color? borderColor]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}
