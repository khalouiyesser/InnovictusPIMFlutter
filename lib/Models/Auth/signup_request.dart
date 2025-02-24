class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String packId;

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.packId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'packId': packId,
    };
  }
}