import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/Views/DashboardClient/Dashboard.dart';
import 'package:piminnovictus/Views/Users/NewPassword.dart';
import 'package:piminnovictus/Views/Users/otp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNavBarExample(), // Affiche le Dashboard directement
    );
  }
}
