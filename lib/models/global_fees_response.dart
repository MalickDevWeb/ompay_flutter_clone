class GlobalFeesResponse {
  final String status;
  final String message;

  GlobalFeesResponse({
    required this.status,
    required this.message,
  });

  factory GlobalFeesResponse.fromJson(Map<String, dynamic> json) {
    return GlobalFeesResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
