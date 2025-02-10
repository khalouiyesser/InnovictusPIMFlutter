// import 'package:flutter/material.dart';
// import 'package:piminnovictus/Views/AuthViews/login_view.dart';
//
// import 'Views/AdminViews/AdminDashboard.dart';
// import 'Views/AuthViews/welcome_view.dart';
//
// void main() {
//   runApp(const MyHomePage(title: 'hello',));
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   //const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return
//
//        MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: LoginView(),
//       );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';

import 'Views/AdminViews/AdminDashboard.dart';
import 'Views/AuthViews/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que Flutter est bien initialisé
  await Firebase.initializeApp(); // Initialisation de Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
