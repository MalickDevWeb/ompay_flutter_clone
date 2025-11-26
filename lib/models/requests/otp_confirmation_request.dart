/// Request model for OTP confirmation of account deletion
class OtpConfirmationRequest {
  final String otpCode;
  final String compteId;

  OtpConfirmationRequest({
    required this.otpCode,
    required this.compteId,
  });

  Map<String, dynamic> toJson() => {
    'otp_code': otpCode,
    'compte_id': compteId,
  };
}

/// Response model for OTP confirmation
class OtpConfirmationResponse {
  final String status;
  final String message;
  final dynamic data;

  OtpConfirmationResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory OtpConfirmationResponse.fromJson(Map<String, dynamic> json) {
    return OtpConfirmationResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'],
    );
  }
}
