class ProfileAccount {
  final String userId;
  final String name;
  final String email;
  final String photoUrl;
  final Map<String, dynamic> userData;

  ProfileAccount({
    required this.userId,
    required this.name,
    required this.email,
    this.photoUrl = '',
    required this.userData,
  });

  factory ProfileAccount.fromJson(Map<String, dynamic> json) {
    return ProfileAccount(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'] ?? '',
      userData: json['userData'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'userData': userData,
    };
  }
}