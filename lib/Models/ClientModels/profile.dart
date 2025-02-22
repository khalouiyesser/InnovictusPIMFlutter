class ProfileModel {
  final String id;
  final String name;
  final String? imageUrl;
  final bool isSelected;

  ProfileModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.isSelected = false,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['image'],
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': imageUrl,
    };
  }
}
