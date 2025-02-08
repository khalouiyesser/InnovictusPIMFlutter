import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/views/login_view.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
              child: Image.asset(
            "assets/Pulse.png",
            fit: BoxFit.cover,
          )),

         Positioned(
          top: 50,
          left:100,
          child:
          Center(
          
           child: Text("Create Account",
          style:  TextStyle(
                color: Colors.white ,
                fontSize: 20,
                fontWeight: FontWeight.bold


          )),
         ))

        ,Align(
          alignment: Alignment.center,
          child: Padding(
          padding: const EdgeInsets.all(20.0), 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                    decoration: InputDecoration(
                      hintText: "First Name",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                        
                      ),
                    ),
                  ),
SizedBox(height: 20,),
                

TextField(
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                        
                      ),
                    ),
                  
                  ),
SizedBox(height: 20,),



TextField(
                    decoration: InputDecoration(
                      hintText: "Eamil",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                        
                      ),
                    ),
                  ),
SizedBox(height: 20,),

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
SizedBox(height: 20,),

                    // Password input field
                  TextField(
                    obscureText: true, // To hide the password text
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),


                  
            ],



          ),



          ),
        ),
        // Positioned Login Button at the bottom
          Positioned(
            bottom: 70, // Distance from the bottom of the screen
            left: 20, // Align with the left
            right: 20, // Align with the right
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 80% width
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 31, 219, 59), // Green background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          left: 50,
          bottom: 30,
          child:Row(
              children: [
                          Text(
                            "Or do you have an account ",style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 
                            ),
                          )
                          ,
                          TextButton(onPressed: (){

                    print("you should navigate to  Login page ");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );


                          }
                          
                          , child: Text(
                              "Login",style:TextStyle(
                               color : Colors.green,

                              )
                          )),
                          


              ],

          )


        )


        ],
      ),
    );
  }
}
