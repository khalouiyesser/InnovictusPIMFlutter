class ProfileAccount {
  final String userId;
  final String name;
  final String email;
  final String photoUrl;
  final Map<String, dynamic> userData;

  ProfileAccount({
    required this.userId,
    required this.name,
    required this.email,
    this.photoUrl = '',
    required this.userData,
  });

  factory ProfileAccount.fromJson(Map<String, dynamic> json) {
    return ProfileAccount(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'] ?? '',
      userData: json['userData'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'userData': userData,
    };
  }
}


//update sale
class ProfileModel {
  final String id;
  final String name;
  final String packId;
  final int energySale;
  final bool isBlocked;
  final String stripeCustomerId;
  final String subscriptionStatus;
  final int totalPayments;
  final int expectedPayments;
  final bool isFullyPaid;
  final String? lastPaymentFailureReason;
  final String? lastPaymentFailureMessage;
  final String? lastPaymentFailureDate;
  final String createdAt;
  final String updatedAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.packId,
    required this.energySale,
    required this.isBlocked,
    required this.stripeCustomerId,
    required this.subscriptionStatus,
    required this.totalPayments,
    required this.expectedPayments,
    required this.isFullyPaid,
    this.lastPaymentFailureReason,
    this.lastPaymentFailureMessage,
    this.lastPaymentFailureDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'],
      packId: json['packId'],
      energySale: json['energySale'],
      isBlocked: json['isBlocked'],
      stripeCustomerId: json['stripeCustomerId'],
      subscriptionStatus: json['subscriptionStatus'],
      totalPayments: json['totalPayments'],
      expectedPayments: json['expectedPayments'],
      isFullyPaid: json['isFullyPaid'],
      lastPaymentFailureReason: json['lastPaymentFailureReason'],
      lastPaymentFailureMessage: json['lastPaymentFailureMessage'],
      lastPaymentFailureDate: json['lastPaymentFailureDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'packId': packId,
      'energySale': energySale,
      'isBlocked': isBlocked,
      'stripeCustomerId': stripeCustomerId,
      'subscriptionStatus': subscriptionStatus,
      'totalPayments': totalPayments,
      'expectedPayments': expectedPayments,
      'isFullyPaid': isFullyPaid,
      'lastPaymentFailureReason': lastPaymentFailureReason,
      'lastPaymentFailureMessage': lastPaymentFailureMessage,
      'lastPaymentFailureDate': lastPaymentFailureDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}