import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Disable resizing of the screen when keyboard appears

      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/panel.png', // Your image path
              fit: BoxFit.cover, // Full screen cover
            ),
          ),

          // Semi-transparent Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), // Dark overlay
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // To center the form
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Email input field
                      TextField(
                        decoration: InputDecoration(
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
                      SizedBox(height: 20), // Space between the fields
                      // Password input field
                      TextField(
                        obscureText: true, // To hide the password text
                        decoration: InputDecoration(
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

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, // Aligns text to the right
                        children: [
                          TextButton(
                            onPressed: () {
                              // Add your forgot password functionality here
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: const Color.fromARGB(173, 181, 179, 179),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                        ,
                        SizedBox(height: 30), // Space between forgot password and login button

                      // Container for the button to set width
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8, // 80% width of screen
                        child: ElevatedButton(
                          onPressed: () {
                            // Add login functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Green background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
  // Container for the button to set width

                



                    ],
                  ),
                ),
              ),
            ),
          ),

// "Login" at the Top Left
          Positioned(
            top: 50, // Adjust as needed
            left: 20, // Adjust as needed
            child: Text(
              "Welcome back",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Positioned(
            top: 80, // Adjust as needed
            left: 20, // Adjust as needed
            child: Text(
              "login ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
