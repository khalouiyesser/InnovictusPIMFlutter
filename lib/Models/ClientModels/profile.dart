class ProfileModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String userId;
  final String packId;
  bool isSelected;

  ProfileModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.userId,
    required this.packId,
    this.isSelected = false,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['image'],
      userId: json['userId'],
      packId: json['packId'],
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': imageUrl,
      'userId': userId,
      'packId': packId,
    };
  }
}