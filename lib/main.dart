import 'package:flutter/material.dart';

import 'Views/AdminViews/AdminDashboard.dart';
import 'Views/AuthViews/welcome_view.dart';

void main() {
  runApp(const MyHomePage(title: 'hello',));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  //const MyHomePage({super.key});

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
