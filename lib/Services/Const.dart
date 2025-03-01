class Const {
  final String url = "http://172.16.0.144:3009";
  final String urlSocket = "http://172.16.0.144:3000";
}

class SessionConstants {
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String expiryKey = 'token_expiry';
  static const int tokenExpiryDays = 30;
}
