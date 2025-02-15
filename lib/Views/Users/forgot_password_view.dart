import 'package:flutter/material.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import '../AuthViews/login_view.dart';
import '../background.dart';
import 'otp.dart';



class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  bool isPhoneInput = false;
  bool isEmailInput = false;
  bool phoneError = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final AuthController con = AuthController();
  bool isEmail(String email) {
    // Expression régulière pour valider une adresse e-mail
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (emailRegex.hasMatch(email)) {
     return true;
    } else {
      return false;
    }
  }

  bool isTunisianNumber(String text) {
    final RegExp tunisianNumberRegex = RegExp(r'^(2|4|5|9)\d{7}$');
    return tunisianNumberRegex.hasMatch(text);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
      false, // Disable resizing of the screen when keyboard appears
      body: Stack(
        children: [
      Positioned.fill(
      child: Image.asset(
        "assets/Pulse.png", // Your background image
        fit: BoxFit.cover, // Ensures the image covers the entire screen
      ),
    ),
        Center(
        child: SafeArea(
          child: Center( // Centre le contenu
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
                crossAxisAlignment: CrossAxisAlignment.center, // Centre horizontalement
                mainAxisSize: MainAxisSize.min, // Ajuste la taille au contenu
                children: [
                                  const SizedBox(height: 1),

                  const Align(
                     alignment: Alignment.centerLeft, // Aligner le texte à gauche4
                     child : Text(

                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  ),

                  const SizedBox(height: 100),
                  // const SizedBox(height: 40),


                  isPhoneInput
                      ? TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone, // Clavier numérique
                    decoration: InputDecoration(
                      hintText: "Enter your phone number",
                      hintStyle: TextStyle(color: Colors.white70), // HintText en blanc
                      prefixIcon: Icon(Icons.phone, color: Colors.white), // Icône téléphone
                      filled: true,
                      fillColor: Colors.grey[800], // Couleur similaire au bouton
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0), // Bordures arrondies
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.green), // Bordure verte au focus
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // Texte en blanc
                    onSubmitted: (_) {
                      setState(() {
                        isPhoneInput = false;
                      });
                    },
                  )
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isPhoneInput = true;
                        isEmailInput = false;
                        emailController.clear();
                      });
                    },
                    child: Container(
                      height: 56, // Hauteur similaire au champ de texte
                      decoration: BoxDecoration(
                        color: Colors.grey[800], // Même couleur que l'input
                        borderRadius: BorderRadius.circular(25.0), // Bordures identiques
                        border: Border.all(color: Colors.white), // Bordure blanche
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, color: Colors.white), // Icône OTP
                          SizedBox(width: 10),
                          Text(
                            "Send OTP via SMS",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                  ),



                  const SizedBox(height: 30),

                  isEmailInput
                      ? TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: Colors.white70), // HintText en blanc
                      prefixIcon: Icon(Icons.email, color: Colors.white), // Icône email
                      filled: true,
                      fillColor: Colors.grey[800], // Même couleur que le bouton
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0), // Bordures arrondies
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.green), // Bordure verte au focus
                      ),
                    ),
                    style: TextStyle(color: Colors.white), // Texte en blanc
                    onSubmitted: (_) {
                      setState(() {
                        isEmailInput = false;
                      });
                    },
                  )
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isEmailInput = true;
                        isPhoneInput = false;
                        phoneController.clear();
                      });
                    },
                    child: Container(
                      height: 56, // Hauteur identique au champ de texte
                      decoration: BoxDecoration(
                        color: Colors.grey[800], // Même couleur que l'input
                        borderRadius: BorderRadius.circular(25.0), // Bordures arrondies
                        border: Border.all(color: Colors.white), // Bordure blanche
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email_outlined, color: Colors.white), // Icône email
                          SizedBox(width: 10),
                          Text(
                            "Send OTP via Email",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),



                  const SizedBox(height: 80),

                  buildActionButton(
                    
                    text: "Continue",
                    
                    backgroundColor: Color(0xFF29E33C),
                    textColor: Colors.white,
                    onTap: () {

                      if(isPhoneInput && phoneController.text.isNotEmpty && isTunisianNumber(phoneController.text)){ // otp par sms


                        con.forgotPassword(emailController.text);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const OTPPage()),
                        // );

                      }else if(isPhoneInput && phoneController.text.isNotEmpty && !isTunisianNumber(phoneController.text)){ // phone input rempli mais le numéro n'est pas vrai
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const OTPPage()),
                        // );
                      }else{
                        con.forgotPassword(emailController.text);
                      }

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
                        MaterialPageRoute(builder: (context) => (LoginView())),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ],
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
          borderRadius: BorderRadius.circular(24),
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
