import 'active_client.dart';

class ActiveClientsResponse {
  final String status;
  final List<ActiveClient> data;

  ActiveClientsResponse({
    required this.status,
    required this.data,
  });

  factory ActiveClientsResponse.fromJson(Map<String, dynamic> json) {
    return ActiveClientsResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => ActiveClient.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((client) => client.toJson()).toList(),
    };
  }
}
