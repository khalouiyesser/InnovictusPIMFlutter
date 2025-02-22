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
}