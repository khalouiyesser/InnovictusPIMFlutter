// ✅ Modèle de réponse (ajoute ce fichier si nécessaire)
class SignupResponse {
  final String token;
  final String userId;

  SignupResponse({required this.token, required this.userId});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      token: json['token'],
      userId: json['userId'],
    );
  }
}