class RestoreAccountResponse {
  final String status;
  final String message;
  final dynamic data;

  RestoreAccountResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory RestoreAccountResponse.fromJson(Map<String, dynamic> json) {
    return RestoreAccountResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'],
    );
  }
}
