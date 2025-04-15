class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String packId;
  final String? idGoogle; 

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.packId,
    this.idGoogle, 
  });

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'packId': packId,
    };
    
    if (idGoogle != null) {
      map['idGoogle'] = idGoogle!;
    }
    
    return map;
  }
}