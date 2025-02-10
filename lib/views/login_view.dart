import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/register_view.dart';
// import 'package:piminnovictus/Views/Users/forgot_password_view.dart';
import 'dart:ui';

import 'Users/forgot_password_view.dart';

// import 'package:piminnovictus/views/register_view.dart';

class LoginView extends StatefulWidget {

   @override
 _LoginViewState createState() =>_LoginViewState();
}



class _LoginViewState extends State<LoginView> 
{


TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String? _emailError = null;
String ?  _passwordError = null;

void _validateEmail(String value)
{
  setState(() {
      if (value.isEmpty) {
        _emailError = "Email cannot be empty";
        print("Email cannot be empty");
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
        _emailError = "Enter a valid email";
        print("Enter a valid email");
      } else {
        _emailError = null;
      }
    });

}
void _validatePassword(String value) {
    setState(() {
      
      if (value.isEmpty) {
        _passwordError = "Password cannot be empty";
                print("Password cannot be empty");

      } else if (value.length < 6) {
        _passwordError = "Password must be at least 6 characters";
    print("Password must be at least 6 characters");

      } else {
        _passwordError = null;
      }
       });
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

          // Centered form content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To center the form
                children: [
                  // Email input field
                  TextField(
                    controller: this.emailController,
                    onChanged: (value) => _validateEmail(value),
                    decoration: InputDecoration(
                      errorText: _emailError,
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Space between fields

                  // Password input field
                  TextField(
                    controller: passwordController,
                    obscureText: true, // To hide the password text
                    onChanged: (value)=>_validatePassword(value),
                    decoration: InputDecoration(
                      errorText: _passwordError,
                      errorStyle: TextStyle(color:Colors.red),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordView()),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Positioned Login Button at the bottom
          Positioned(
            bottom: 100, // Distance from the bottom of the screen
            left: 20, // Align with the left
            right: 20, // Align with the right
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 80% width
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                    this._validateEmail(emailController.text);
                    _validatePassword(passwordController.text);
                   bool ok =  validateform();                    


                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 31, 219, 59), // Green background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          // Positioned "You don't have an account yet?" text at the bottom
          Positioned(
            bottom: 30, // Distance from the bottom of the screen
            left: 10, // Align with the left
            right: 20, // Align with the right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You don't have an account yet? ",
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                    fontSize: 14, // Adjust font size as needed
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("you should navigate to  sign up page ");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  child: Text(
                    "sign up",
                    style: TextStyle(
                      color: Colors.green, // Or another contrasting color
                      fontSize: 14, // Adjust font size as needed
                    ),
                  ),
                )
              ],
            ),
          ),

          // "Welcome back" text with subtle green glow effect
          Positioned(
            top: 50, // Adjust as needed
            left: 20, // Adjust as needed
            child: Text(
              "Welcome back",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0), // Green shadow
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // "Login" text with green effect
          Positioned(
            top: 80, // Adjust as needed
            left: 20, // Adjust as needed
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.normal,
                shadows: [
                  Shadow(
                    color: Colors.green.withOpacity(0.6), // Green shadow
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  bool validateform() {
    if(!emailController.text.isEmpty &&!passwordController.text.isEmpty)
    {
      if(_emailError==null && _passwordError == null)
      {
        print("navigate to the dashboard page ");
        return true ;
      }

      
    }
    else 
    {
      print("conditions not matches");
      _validateEmail(emailController.text);
      _validatePassword(passwordController.text);
      return false;

    }


return false ;

  }
  
 
 }
