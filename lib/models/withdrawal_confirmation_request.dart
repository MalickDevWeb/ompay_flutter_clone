class WithdrawalConfirmationRequest {
  final String confirmationCode;

  WithdrawalConfirmationRequest({
    required this.confirmationCode,
  });

  Map<String, dynamic> toJson() => {
    'confirmation_code': confirmationCode,
  };
}
