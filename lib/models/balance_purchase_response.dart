class BalancePurchaseResponse {
  final String status;
  final String message;

  BalancePurchaseResponse({
    required this.status,
    required this.message,
  });

  factory BalancePurchaseResponse.fromJson(Map<String, dynamic> json) {
    return BalancePurchaseResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
