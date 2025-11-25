import 'transaction_model.dart';

class TransactionResponse {
  final String status;
  final String message;
  final TransactionData data;

  TransactionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: TransactionData.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionData {
  final int currentPage;
  final List<TransactionModel> data;
  final int perPage;
  final int total;

  TransactionData({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.total,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      currentPage: (json['current_page'] as int?) ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      perPage: (json['per_page'] as int?) ?? 0,
      total: (json['total'] as int?) ?? 0,
    );
  }
}
