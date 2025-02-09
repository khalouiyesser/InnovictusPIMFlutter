// import 'package:flutter/material.dart';
// import 'package:piminnovictus/Views/login_view.dart';
// import 'background.dart';
//
// class ForgotPasswordView extends StatefulWidget {
//   const ForgotPasswordView({Key? key}) : super(key: key);
//
//   @override
//   _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
// }
//
// class _ForgotPasswordViewState extends State<ForgotPasswordView> {
//   bool isPhoneInput = false;
//   bool isEmailInput = false;
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: BlurredRadialBackground(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center
//               ,
//               children: [
//                 const SizedBox(height: 40),
//
//                 // Titre "Forgot Password?"
//                 const Text(
//                   "Forgot Password?",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//
//                 const SizedBox(height: 40),
//
//
//                 // Champ pour entrer le numéro de téléphone ou bouton
//                 isPhoneInput
//                     ? buildTextField(
//                   controller: phoneController,
//                   hintText: "Enter your phone number",
//                   icon: Icons.phone,
//                   onSubmitted: () => setState(() => isPhoneInput = false),
//                 )
//                     : buildOptionButton(
//                   icon: Icons.chat_bubble_outline,
//                   text: "Send OTP via SMS",
//                   onTap: () {
//                     setState(() {
//                       isPhoneInput = true;
//                       isEmailInput = false;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 15),
//
//                 // Champ pour entrer l'email ou bouton
//                 isEmailInput
//                     ? buildTextField(
//                   controller: emailController,
//                   hintText: "Enter your email",
//                   icon: Icons.email,
//                   onSubmitted: () => setState(() => isEmailInput = false),
//                 )
//                     : buildOptionButton(
//                   icon: Icons.email_outlined,
//                   text: "Send OTP via Email",
//                   onTap: () => setState(() { isEmailInput = true;isPhoneInput = false;}),
//                 ),
//                 const SizedBox(height: 30),
//
//                 // Bouton "Continue"
//                 buildActionButton(
//                   text: "Continue",
//                   backgroundColor: Colors.green,
//                   textColor: Colors.white,
//                   onTap: () {
//                     // Ajoute ici l'action pour continuer
//                   },
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 // Bouton "Back to Login"
//                 buildActionButton(
//                   text: "Back To Login",
//                   backgroundColor: Colors.transparent,
//                   textColor: Colors.green,
//                   borderColor: Colors.green,
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginView()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildOptionButton({required IconData icon, required String text, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           color: Colors.grey[800],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 20),
//             const SizedBox(width: 10),
//             Text(
//               text,
//               style: const TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildActionButton({
//     required String text,
//     required Color backgroundColor,
//     required Color textColor,
//     Color? borderColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(10),
//           border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     required VoidCallback onSubmitted,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         controller: controller,
//         style: const TextStyle(color: Colors.white),
//         keyboardType: hintText.contains("phone") ? TextInputType.phone : TextInputType.emailAddress,
//         decoration: InputDecoration(
//           icon: Icon(icon, color: Colors.white),
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.white70),
//           border: InputBorder.none,
//         ),
//         onSubmitted: (value) => onSubmitted(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/login_view.dart';
import 'background.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  bool isPhoneInput = false;
  bool isEmailInput = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlurredRadialBackground(
        child: SafeArea(
          child: Center( // Centre le contenu
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
                crossAxisAlignment: CrossAxisAlignment.center, // Centre horizontalement
                mainAxisSize: MainAxisSize.min, // Ajuste la taille au contenu
                children: [
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  isPhoneInput
                      ? buildTextField(
                    controller: phoneController,
                    hintText: "Enter your phone number",
                    icon: Icons.phone,
                    onSubmitted: () {
                      setState(() {
                        isPhoneInput = false;
                      });
                    },
                  )
                      : buildOptionButton(
                    icon: Icons.chat_bubble_outline,
                    text: "Send OTP via SMS",
                    onTap: () {
                      setState(() {
                        isPhoneInput = true;
                        isEmailInput = false;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  isEmailInput
                      ? buildTextField(
                    controller: emailController,
                    hintText: "Enter your email",
                    icon: Icons.email,
                    onSubmitted: () {
                      setState(() {
                        isEmailInput = false;
                      });
                    },
                  )
                      : buildOptionButton(
                    icon: Icons.email_outlined,
                    text: "Send OTP via Email",
                    onTap: () {
                      setState(() {
                        isEmailInput = true;
                        isPhoneInput = false;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  buildActionButton(
                    text: "Continue",
                    backgroundColor: Color(0xFF29E33C),
                    textColor: Colors.white,
                    onTap: () {
                      // Ajoute ici l'action pour continuer
                    },
                  ),

                  const SizedBox(height: 15),

                  buildActionButton(
                    text: "Back To Login",
                    backgroundColor: Colors.transparent,
                    textColor: Colors.green,
                    borderColor: Color(0xFF29E33C),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOptionButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget buildActionButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required VoidCallback onSubmitted,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: hintText.contains("phone") ? TextInputType.phone : TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        onSubmitted: (value) => onSubmitted(),
      ),
    );
  }
}
