class SignupResponse {
  final String message;
  final String pendingSignupId;
  final String defaultProfileId;

  SignupResponse({
    required this.message,
    required this.pendingSignupId,
    required this.defaultProfileId,

  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] ?? '',
      pendingSignupId: json['pendingSignupId'] ?? '',
      defaultProfileId: json['defaultProfileId'] ?? '',

    );
  }
}
