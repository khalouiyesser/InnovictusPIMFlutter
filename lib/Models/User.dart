class User {
  final String id;
  final String name;
  final String? image;
  final DateTime? lastSeen;
  
  User({
    required this.id,
    required this.name,
    this.image,
    this.lastSeen,
  });
}