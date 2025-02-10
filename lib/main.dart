import 'package:flutter/material.dart';
import 'package:piminnovictus/views/AdminViews/AdminDashboard.dart';
import 'package:piminnovictus/views/AuthViews/welcome_view.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return 
    
       MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      );
  }
}
