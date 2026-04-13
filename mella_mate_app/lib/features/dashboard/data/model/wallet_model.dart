class Wallet {
  final String publicKey;
  final String? secretKey;
  final String network;
  final bool funded;

  Wallet({
    required this.publicKey,
    this.secretKey,
    required this.network,
    required this.funded,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      publicKey: json['public_key'] ?? '',
      secretKey: json['secret_key'],
      network: json['network'] ?? 'TESTNET',
      funded: json['funded'] ?? false,
    );
  }
}

class Balance {
  final String amount;
  final String assetCode;
  final String? assetIssuer;

  Balance({
    required this.amount,
    required this.assetCode,
    this.assetIssuer,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      amount: json['balance'] ?? '0.0',
      assetCode: json['asset_code'] ?? (json['asset_type'] == 'native' ? 'XLM' : 'UNKNOWN'),
      assetIssuer: json['asset_issuer'],
    );
  }
}
