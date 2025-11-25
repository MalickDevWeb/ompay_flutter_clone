class UpdateTransferRightsResponse {
  final String status;
  final String message;

  UpdateTransferRightsResponse({
    required this.status,
    required this.message,
  });

  factory UpdateTransferRightsResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTransferRightsResponse(
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
