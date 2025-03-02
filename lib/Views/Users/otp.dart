//
// import 'package:flutter/material.dart';
// import 'package:piminnovictus/Services/AuthController.dart';
// import 'package:piminnovictus/Views/Users/NewPassword.dart';
// import 'dart:ui';
// import 'package:piminnovictus/Views/bachground.dart';
//
// class OTPPage extends StatefulWidget {
//   final String email;
//   final String resetToken;
//   final int code;
//
//   const OTPPage({
//     super.key,
//     required this.email,
//     required this.resetToken,
//     required this.code,
//   });
//
//   @override
//   _OTPPageState createState() => _OTPPageState();
// }
//
// class _OTPPageState extends State<OTPPage> {
//   List<String> otpCode = List.filled(6, "");
//   late List<FocusNode> focusNodes;
//   final AuthController con = AuthController();
//
//   late String resetToken;
//   late int code;
//
//   @override
//   void initState() {
//     super.initState();
//     focusNodes = List.generate(6, (index) => FocusNode());
//     resetToken = widget.resetToken;
//     code = widget.code;
//
//     print("OTPPage - Email: ${widget.email}, ResetToken: $resetToken, Code: $code");
//   }
//
//   @override
//   void dispose() {
//     for (var node in focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlurredRadialBackground(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 50),
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Enter OTP Code",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 70),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(
//                     6,
//                         (index) => SizedBox(
//                       width: 50,
//                       height: 50,
//                       child: TextField(
//                         focusNode: focusNodes[index],
//                         textAlign: TextAlign.center,
//                         keyboardType: TextInputType.number,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey[800],
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(7),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         maxLength: 1,
//                         buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
//                         onChanged: (value) {
//                           if (value.isNotEmpty && index < 5) {
//                             FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//                           }
//                           otpCode[index] = value;
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       String otp = otpCode.join();
//                       print("OTP entré : $otp");
//
//                       if (otp == code ){
//
//                         await Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                             builder: (context) => NewPasswordPage(
//                               resetToken: resetToken,
//                             ),
//                           ),
//                         );
//                       }else{
//                         print("aaa");
//                         print(code);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.greenAccent[700],
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: const Text(
//                       "Verify the code ",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "You have not received the code ?",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 GestureDetector(
//                   onTap: () async {
//                     final response = await con.forgotPassword(widget.email);
//
//                     if (response != null) {
//                       setState(() {
//                         resetToken = response["resetToken"];
//                         code = response["code"];
//                       });
//                       print("Nouveau ResetToken: $resetToken, Nouveau Code: $code");
//                     }
//                   },
//                   child: const Text(
//                     "Resend",
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
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
// }
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Services/AuthController.dart';
import 'package:piminnovictus/Views/Users/NewPassword.dart';
import 'package:piminnovictus/Views/bachground.dart';

class OTPPage extends StatefulWidget {
  final String email;
  final String resetToken;
  final int code;

  const OTPPage({
    super.key,
    required this.email,
    required this.resetToken,
    required this.code,
  });

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> with WidgetsBindingObserver {
  List<String> otpCode = List.filled(6, "");
  late List<FocusNode> focusNodes;
  final AuthController con = AuthController();
  late AuthScreenTheme _theme;

  late String resetToken;
  late int code;

  @override
  void initState() {
    super.initState();
    _updateTheme();
    // S'enregistre pour écouter les changements de luminosité du système
    WidgetsBinding.instance.addObserver(this);

    focusNodes = List.generate(6, (index) => FocusNode());
    resetToken = widget.resetToken;
    code = widget.code;

    print(
        "OTPPage - Email: ${widget.email}, ResetToken: $resetToken, Code: $code");
  }

  @override
  void didChangePlatformBrightness() {
    // Mettre à jour le thème quand la luminosité du système change
    if (mounted) {
      setState(() {
        _updateTheme();
      });
    }
  }

  void _updateTheme() {
    _theme = AuthScreenThemeDetector.getTheme();
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
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

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
                  alignment: Alignment.centerLeft,
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
                          if (value.isNotEmpty) {
                            otpCode[index] = value;
                            if (index < 5) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index + 1]);
                            }
                          } else {
                            otpCode[index] = "";
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      String otp = otpCode.join();
                      print("OTP entré : $otp");

                      if (otp.length == 6 && int.tryParse(otp) == code) {
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => NewPasswordPage(
                              resetToken: resetToken,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Code incorrect, veuillez réessayer."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Verify the code",
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
                  "You have not received the code?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () async {
                    final response = await con.forgotPassword(widget.email);

                    if (response != null) {
                      setState(() {
                        resetToken = response["resetToken"];
                        code = response["code"];
                      });
                      print(
                          "Nouveau ResetToken: $resetToken, Nouveau Code: $code");
                    }
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
