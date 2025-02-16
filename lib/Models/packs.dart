class Pack {
  final String id;
  final String title;
  final String image;
  final String description;
  final String price;
  final String panelsCount;
  final String energyGain;
  final String co2Saved;
  final String certification;

  Pack({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    this.price = '',
    this.panelsCount = '',
    this.energyGain = '',
    this.co2Saved = '',
    this.certification = '',
  });

  // Convert Map to Pack object
  factory Pack.fromMap(Map<String, String> map) {
    return Pack(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      panelsCount: map['panels_count'] ?? '',
      energyGain: map['energy_gain'] ?? '',
      co2Saved: map['co2_saved'] ?? '',
      certification: map['certification'] ?? '',
    );
  }

  // Convert Pack object to Map
  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'price': price,
      'panels_count': panelsCount,
      'energy_gain': energyGain,
      'co2_saved': co2Saved,
      'certification': certification,
    };
  }

  // Create a copy of Pack with modified fields
  Pack copyWith({
    String? id,
    String? title,
    String? image,
    String? description,
    String? price,
    String? panelsCount,
    String? energyGain,
    String? co2Saved,
    String? certification,
  }) {
    return Pack(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      price: price ?? this.price,
      panelsCount: panelsCount ?? this.panelsCount,
      energyGain: energyGain ?? this.energyGain,
      co2Saved: co2Saved ?? this.co2Saved,
      certification: certification ?? this.certification,
    );
  }
}