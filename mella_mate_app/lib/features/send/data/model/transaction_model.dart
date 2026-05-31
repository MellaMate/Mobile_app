class Transaction {
  final String id;
  final String hash;
  final double amount;
  final String currency;
  final String status;
  final String direction;
  final String counterparty;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.hash,
    required this.amount,
    required this.currency,
    required this.status,
    required this.direction,
    required this.counterparty,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      hash: json['txHash'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USDC',
      status: json['status'] ?? 'pending',
      direction: json['direction'] ?? 'IN',
      counterparty: json['counterparty'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class SendPaymentRequest {
  final String destination;
  final String amount;
  final String assetCode;
  final String? assetIssuer;
  final String? memo;

  SendPaymentRequest({
    required this.destination,
    required this.amount,
    required this.assetCode,
    this.assetIssuer,
    this.memo,
  });

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'amount': amount,
      'asset': {
        'code': assetCode,
        'issuer': assetIssuer,
      },
      'memo': memo,
    };
  }
}
