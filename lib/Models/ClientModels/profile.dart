class ProfileModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String userId;
  final String packId;
  bool isSelected;
  DateTime lastUsed;
  DateTime createdAt;  // Add this field

  ProfileModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.userId,
    required this.packId,
    this.isSelected = false,
    DateTime? lastUsed,
    DateTime? createdAt,  // Make it optional
  }) : 
    this.lastUsed = lastUsed ?? DateTime.now(),
    this.createdAt = createdAt ?? DateTime.now();  // Default to current time if not provided

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['image'],
      userId: json['userId'],
      packId: json['packId'],
      isSelected: false,
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': imageUrl,
      'userId': userId,
      'packId': packId,
      'lastUsed': lastUsed.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
  String getTimeAgo([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    final difference = now.difference(lastUsed);

    if (difference.inSeconds < 60) {
      return "à l'instant";
    }
    
    if (difference.inMinutes < 60) {
      return "il y a ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}";
    }
    
    if (difference.inHours < 24) {
      return "il y a ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}";
    }
    
    if (difference.inDays < 7) {
      return "il y a ${difference.inDays} ${difference.inDays == 1 ? 'jour' : 'jours'}";
    }

    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "il y a ${weeks} ${weeks == 1 ? 'semaine' : 'semaines'}";
    }

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "il y a ${months} ${months == 1 ? 'mois' : 'mois'}";
    }

    final years = (difference.inDays / 365).floor();
    return "il y a ${years} ${years == 1 ? 'an' : 'ans'}";
  }
}