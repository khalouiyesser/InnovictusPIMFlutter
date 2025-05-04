class Const {
  //final String url = "http://192.168.1.122:3000"; // kahwetkom 1
  final String url = "http://172.16.10.195:3009"; //dar shayma
  //final String url = "http://192.168.93.55:3009"; // Dar yesser
  // final String url = "http://10.0.2.2:3009"; // Dar yesser
  final String urlSocket = "http://172.16.10.195:3000";
  final String urlBlockChain = "http://172.16.10.195:5000";
}

class SessionConstants {
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String expiryKey = 'token_expiry';
  static const int tokenExpiryDays = 30;
}
