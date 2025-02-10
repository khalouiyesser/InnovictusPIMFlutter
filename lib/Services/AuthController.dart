

import 'dart:convert';

import 'package:piminnovictus/Services/Const.dart';
import 'package:http/http.dart' as http;

class AuthController{
  final Const con = Const(); // Suppression de 'Const' en tant que type, c'est une classe
  String api;

  AuthController() : api = Const().url; // Initialisation correcte de 'api'


  Future<Map<String, dynamic>> ForgotPassword(
       String newPassword) async {
    final response = await http.post(
      Uri.parse("$api/auth/forgot-password"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': newPassword,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      print(response.body);
      // Si la requête réussit, retournez les données de la réponse
      return json.decode(response.body);
    } else {
      // Si la requête échoue, lancez une exception
      throw Exception('Failed to send Otp');
    }
  }

}