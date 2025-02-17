// import 'package:flutter/material.dart';
// import 'package:piminnovictus/Services/AuthController.dart';
// import 'dart:ui';
//
// import 'package:piminnovictus/Views/bachground.dart';
//
// class NewPasswordPage extends StatefulWidget {
//   const NewPasswordPage({super.key, required this.resetToken});
//   final String resetToken;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   @override
//   _NewPasswordPageState createState() => _NewPasswordPageState();
// }
//
// class _NewPasswordPageState extends State<NewPasswordPage> {
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   AuthController authController = AuthController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlurredRadialBackground(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 40),
//                 const Text(
//                   "Enter New Password",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 80),
//
//                 // Password Field
//                 _buildPasswordField("Password", _obscurePassword, () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 }),
//
//                 const SizedBox(height: 15),
//
//                 // Confirm Password Field
//                 _buildPasswordField("Confirm Password", _obscureConfirmPassword,
//                     () {
//                   setState(() {
//                     _obscureConfirmPassword = !_obscureConfirmPassword;
//                   });
//                 }),
//
//                 const SizedBox(height: 40),
//
//                 // Save Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//
//                       authController.resetPassword(resetToken, newPassword);
//
//                       // Action à exécuter lors de la validation du mot de passe
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           const Color(0xFF29E33C), // ✅ Couleur verte (29E33C)
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: const Text(
//                       "Save",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPasswordField(
//       String hint, bool obscureText, VoidCallback toggleVisibility) {
//     return TextField(
//       obscureText: obscureText,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.grey[800],
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.white70),
//         suffixIcon: IconButton(
//           icon: Icon(
//             obscureText ? Icons.visibility_off : Icons.visibility,
//             color: Colors.white70,
//           ),
//           onPressed: toggleVisibility,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: const BorderSide(color: Colors.transparent),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: const BorderSide(
//               color: Color(0xFF29E33C), width: 1), // ✅ Bordure verte (29E33C)
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'dart:ui';
import 'package:piminnovictus/Views/bachground.dart';

class NewPasswordPage extends StatefulWidget {
  final String resetToken;

  const NewPasswordPage({super.key, required this.resetToken});

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final AuthController authController = AuthController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("Reset Token reçu : ${widget.resetToken}");
  }

  Future<void> _validateAndSubmit() async {
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Vérification si les mots de passe sont identiques
    if (password != confirmPassword) {
      _showErrorDialog("Passwords do not match!");
      return;
    }

    // Vérification de la longueur du mot de passe
    if (password.length < 6) {
      _showErrorDialog("Password must be at least 6 characters long!");
      return;
    }

    // Vérification si le mot de passe contient au moins un chiffre
    if (!RegExp(r'^(?=.*[0-9])').hasMatch(password)) {
      _showErrorDialog("Password must contain at least one number!");
      return;
    }

    // Si tout est valide, appeler la méthode pour réinitialiser le mot de passe
    authController.resetPassword(widget.resetToken, password);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
    );
    print("Password reset request sent!");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredRadialBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Enter New Password",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 80),

                // Password Field
                _buildPasswordField("Password", passwordController, _obscurePassword, () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                }),

                const SizedBox(height: 15),

                // Confirm Password Field
                _buildPasswordField("Confirm Password", confirmPasswordController, _obscureConfirmPassword, () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                }),

                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF29E33C), // ✅ Couleur verte (29E33C)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildPasswordField(
      String hint, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: toggleVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF29E33C), width: 1), // ✅ Bordure verte (29E33C)
        ),
      ),
    );
  }
}
