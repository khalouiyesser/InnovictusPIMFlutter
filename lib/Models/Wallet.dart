class Wallet {
  final String accountId;
  final String privateKey;

  Wallet({required this.accountId, required this.privateKey});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      accountId: json['accountId'],
      privateKey: json['privateKey'],
    );
  }
}
