class DeleteAccountResponse {
  final String status;
  final String message;
  final dynamic data;

  DeleteAccountResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'],
    );
  }
}
