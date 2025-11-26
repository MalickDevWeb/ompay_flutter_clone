import '../requests/pending_balance_request.dart';

class PendingBalanceRequestsResponse {
  final String status;
  final List<PendingBalanceRequest> data;

  PendingBalanceRequestsResponse({
    required this.status,
    required this.data,
  });

  factory PendingBalanceRequestsResponse.fromJson(Map<String, dynamic> json) {
    return PendingBalanceRequestsResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => PendingBalanceRequest.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((request) => request.toJson()).toList(),
    };
  }
}
