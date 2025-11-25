class ConfirmWithdrawalRequest {
  final String transactionId;
  final String otpCode;

  ConfirmWithdrawalRequest({
    required this.transactionId,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => {
    'transaction_id': transactionId,
    'otp_code': otpCode,
  };
}
