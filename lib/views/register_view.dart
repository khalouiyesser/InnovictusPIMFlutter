import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/views/login_view.dart';

class RegisterView extends StatefulWidget {
@override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final TextEditingController firstNameController = TextEditingController() ;
  final TextEditingController  lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmPasswordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  //final FocusNode _confirmPasword = FocusNode();
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _firstNameError ; 
  String? _lastNameError;


@override
  void initState() {
    super.initState();


        // Listen to input changes and validate
            emailController.addListener(() {
              _validateEmail(emailController.text);
            });

            firstNameController.addListener(() {
                 _validateFirstName(firstNameController.text);
                });

                lastNameController.addListener((){

                  _validateLastName(lastNameController.text);
                }
                );

                passwordController.addListener((){

                  _validatePassword(passwordController.text);
                 _validataConfirmPassword(ConfirmPasswordController.text);

                }
                );

                   ConfirmPasswordController.addListener((){

                  _validataConfirmPassword(ConfirmPasswordController.text);
                }
                );



  }


   @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _validateLastName(String value)
  {
    setState(() {
        if(value.isEmpty)
        {
          _lastNameError = "LastName cannot be empty";
        }
        else if(value.length<3)
        {
          _lastNameError = "LastName should be at least 3 caracters";

        }
        else
         {
          _lastNameError = null;
         }



    });


  }
void _validataConfirmPassword(String value)
{
  setState(() {
    if(value.isEmpty)
    {
       _confirmPasswordError = "Confirm Password cannot be empty";
             print("Confirm Password cannot be empty");

    }
    else if (value != this.passwordController.text)
    {
      // ignore: prefer_interpolation_to_compose_strings
      _confirmPasswordError = "${value}passwords don't match :"  ;
      print("password don't march ");
    }
    else{

      _confirmPasswordError =null;
        print("we are good ");
    }

  });
}


  void _validateEmail(String value) {
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
    
     
  

  _validateFirstName(String value) {
    setState(() {
      if(value.isEmpty)
      {
        this._firstNameError = "FirstName cannot be Empty";
      }
      else if(value.length<3)
      {
          this._firstNameError = "FirstName should be at least 3 caractres ";
      }
      else
      {
        this._firstNameError = null;
      }

    });


  }


void _submitForm()
{
  print("submit form function is called");
  if(!ConfirmPasswordController.text.isEmpty&&!passwordController.text.isEmpty&&!emailController.text.isEmpty&&!firstNameController.text.isEmpty&&!lastNameController.text.isEmpty)
  {

  if(_confirmPasswordError == null && _passwordError ==null &&_emailError == null && _firstNameError==null && _lastNameError ==null)
  {
    print("we received your demande we will contac tyou soon ");
  }
  else
  {
    print("donner invalide");
  }}
  else
  {
    print("is empty");
    _lastNameError = "last name is empty submit";
    _validateEmail(this.emailController.text);
    _validatePassword(this.passwordController.text);
    _validataConfirmPassword(this.ConfirmPasswordController.text);
    _validateFirstName(this.firstNameController.text);
    _validateLastName(this.lastNameController.text);

  }
}











 
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
                controller: this.firstNameController,
                onChanged: (value) => _validateFirstName(value),
                    decoration: InputDecoration(
                      errorText: this._firstNameError,
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: "First Name",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                       )

                        ,
                        // Border when the field is focused
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _firstNameError != null ? Colors.red :!firstNameController.text.isEmpty? Colors.green:Colors.red, 
                                width: 2,
                              ),
                            ),

                        // Border when the field is enabled but not focused
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _firstNameError != null  ? Colors.red :!firstNameController.text.isEmpty? Colors.green:Colors.white, 
                                width: 1,
                              ),
                            ),




                    ),
                  ),
                 
SizedBox(height: 20,),
                

TextField(controller: this.lastNameController,
                    onChanged: (value) => _validateLastName(value),
                    decoration: InputDecoration(
                      errorText: _lastNameError,
                      errorStyle: TextStyle(color:Colors.red),
                      hintText: "Last Name",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        
                      ),




                                   // Border when the field is focused
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _lastNameError != null ? Colors.red :!lastNameController.text.isEmpty? Colors.green:Colors.red, 
                                width: 2,
                              ),
                            ),

                        // Border when the field is enabled but not focused
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _lastNameError != null  ? Colors.red :!lastNameController.text.isEmpty? Colors.green:Colors.white, 
                                width: 1,
                              ),
                            ),








                    ),
                  
                  ),
SizedBox(height: 20,),



TextField(
                      controller: this.emailController,
                        onChanged: (value) => _validateEmail(value),  // <-- Validate immediately on change

                    focusNode: this._emailFocus,
                    decoration: InputDecoration(
                      errorText: this._emailError,
                  errorStyle: TextStyle(color: Colors.red), // Set error message color to red
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        
                      ),



        // Border when the field is focused
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _emailError != null ? Colors.red :!emailController.text.isEmpty? Colors.green:Colors.red, 
                                width: 2,
                              ),
                            ),

                        // Border when the field is enabled but not focused
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _emailError != null  ? Colors.red :!emailController.text.isEmpty? Colors.green:Colors.white, 
                                width: 1,
                              ),
                            ),








                    ),
                  ),
SizedBox(height: 20,),

  // Password input field
                  TextField(
               onChanged: (value) => _validatePassword(value),  // <-- Validate immediately on change

                    controller : this.passwordController ,                
                     obscureText: true, // To hide the password text
                    decoration: InputDecoration(
                      errorText: this._passwordError,
                      errorStyle: TextStyle(color:Colors.red),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),




                               focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _passwordError != null ? Colors.red :!passwordController.text.isEmpty? Colors.green:Colors.red, 
                                width: 2,
                              ),
                            ),

                        // Border when the field is enabled but not focused
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _confirmPasswordError != null  ? Colors.red :!passwordController.text.isEmpty? Colors.green:Colors.white, 
                                width: 1,
                              ),
                            ),











                    ),
                  ),

                    SizedBox(height: 20,),

                    // Password input field
                  TextField(
                    onChanged: (value) => this._validataConfirmPassword(value),
                    controller: this.ConfirmPasswordController,
                    obscureText: true, // To hide the password text
                    decoration: InputDecoration(
                      errorText: this._confirmPasswordError,
                      errorStyle: TextStyle(color: _confirmPasswordError!=null ? Colors.red : Colors.green),
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),



                               focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _confirmPasswordError != null ? Colors.red :!ConfirmPasswordController.text.isEmpty? Colors.green:Colors.red, 
                                width: 2,
                              ),
                            ),

                        // Border when the field is enabled but not focused
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _confirmPasswordError != null  ? Colors.red :!ConfirmPasswordController.text.isEmpty? Colors.green:Colors.white, 
                                width: 1,
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
            bottom: 50, // Distance from the bottom of the screen
            left: 20, // Align with the left
            right: 20, // Align with the right
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 80% width
              height: 50,
              child: ElevatedButton(
                onPressed: () {

                    this._submitForm();

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
          bottom: 17,
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
                               fontSize: 14

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
