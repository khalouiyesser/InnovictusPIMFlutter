class Pack {
  final String? id;
  final String title;
  final String description;
  final double price;
  final double panels;
  final double generated;
  final double gain;
  final int fossil;
  final String image; // Ajout de la propriété image
  
  Pack({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.panels,
    required this.generated,
    required this.gain,
    required this.fossil,
    this.image = "assets/panel.png", // Valeur par défaut
  });
  
  factory Pack.fromJson(Map<String, dynamic> json) {
    return Pack(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'] is int ? (json['price'] as int).toDouble() : json['price'],
      panels: json['panels'] is int ? (json['panels'] as int).toDouble() : json['panels'],
      generated: json['generated'] is int ? (json['generated'] as int).toDouble() : json['generated'],
      gain: json['gain'] is int ? (json['gain'] as int).toDouble() : json['gain'],
      fossil: json['fossil'],
      image: json['image'] ?? "assets/panel.png", // Gérer le cas où l'image n'est pas fournie
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'panels': panels,
      'generated': generated,
      'gain': gain,
      'fossil': fossil,
      'image': image,
    };
  }
  
  Pack copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    double? panels,
    double? generated,
    double? gain,
    int? fossil,
    String? image,
  }) {
    return Pack(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      panels: panels ?? this.panels,
      generated: generated ?? this.generated,
      gain: gain ?? this.gain,
      fossil: fossil ?? this.fossil,
      image: image ?? this.image,
    );
  }
  
  @override
  String toString() {
    return 'Pack(id: $id, title: $title, price: $price, panels: $panels, generated: $generated, gain: $gain, fossil: $fossil, image: $image)';
  }
}