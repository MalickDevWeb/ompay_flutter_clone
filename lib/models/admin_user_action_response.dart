class AdminUserActionResponse {
  final String status;
  final String message;

  AdminUserActionResponse({
    required this.status,
    required this.message,
  });

  factory AdminUserActionResponse.fromJson(Map<String, dynamic> json) {
    return AdminUserActionResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
