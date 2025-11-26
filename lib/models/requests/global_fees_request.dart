class GlobalFeesRequest {
  final double transactionFee;
  final double merchantPercentage;

  GlobalFeesRequest({
    required this.transactionFee,
    required this.merchantPercentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'transaction_fee': transactionFee,
      'merchant_percentage': merchantPercentage,
    };
  }

  factory GlobalFeesRequest.fromJson(Map<String, dynamic> json) {
    return GlobalFeesRequest(
      transactionFee: (json['transaction_fee'] as num).toDouble(),
      merchantPercentage: (json['merchant_percentage'] as num).toDouble(),
    );
  }
}
