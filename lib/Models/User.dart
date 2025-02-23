class User {
  final String id;
  final String name;
  final String? image;
  final DateTime? lastSeen;
  final String? email;

  User({
    required this.id,
    required this.name,
    this.image,
    this.lastSeen,
    this.email,
  });

  // Factory method to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '', // Ajout de l'email

      image: json['image'],
      lastSeen:
          json['lastSeen'] != null ? DateTime.tryParse(json['lastSeen']) : null,
    );
  }
}