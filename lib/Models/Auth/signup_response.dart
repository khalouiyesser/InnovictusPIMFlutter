class SignupResponse {
  final String message;
  final String pendingSignupId;

  SignupResponse({
    required this.message,
    required this.pendingSignupId,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] ?? '',
      pendingSignupId: json['pendingSignupId'] ?? '',
    );
  }
}
