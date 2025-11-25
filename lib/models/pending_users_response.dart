import 'pending_user.dart';

class PendingUsersResponse {
  final String status;
  final List<PendingUser> data;

  PendingUsersResponse({
    required this.status,
    required this.data,
  });

  factory PendingUsersResponse.fromJson(Map<String, dynamic> json) {
    return PendingUsersResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => PendingUser.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((user) => user.toJson()).toList(),
    };
  }
}
