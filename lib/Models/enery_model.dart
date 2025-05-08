class EnergyModel {
  final String profileId;
  final double energySalePercentage;
  final bool isBlocked;
  final String? stripeCustomerId;
  final String? subscriptionStatus;
  
  EnergyModel({
    required this.profileId,
    required this.energySalePercentage,
    this.isBlocked = false,
    this.stripeCustomerId,
    this.subscriptionStatus,
  });
  
  // Factory constructor pour créer un modèle à partir d'une réponse JSON
  factory EnergyModel.fromJson(Map<String, dynamic> json) {
    return EnergyModel(
      profileId: json['_id'] ?? '',
      energySalePercentage: (json['energySale'] ?? 0).toDouble(),
      isBlocked: json['isBlocked'] ?? false,
      stripeCustomerId: json['stripeCustomerId'],
      subscriptionStatus: json['subscriptionStatus'],
    );
  }
  
  // Méthode pour convertir le modèle en Map pour les requêtes API
  Map<String, dynamic> toJson() {
    return {
      'sale': energySalePercentage.toInt(),
    };
  }
  
  // Créer une copie du modèle avec des propriétés spécifiques modifiées
  EnergyModel copyWith({
    String? profileId,
    double? energySalePercentage,
    bool? isBlocked,
    String? stripeCustomerId,
    String? subscriptionStatus,
  }) {
    return EnergyModel(
      profileId: profileId ?? this.profileId,
      energySalePercentage: energySalePercentage ?? this.energySalePercentage,
      isBlocked: isBlocked ?? this.isBlocked,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }
}