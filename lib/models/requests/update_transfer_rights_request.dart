class UpdateTransferRightsRequest {
  final bool transferEnabled;
  final bool canTransferToClient;
  final bool canPayMerchant;

  UpdateTransferRightsRequest({
    required this.transferEnabled,
    required this.canTransferToClient,
    required this.canPayMerchant,
  });

  Map<String, dynamic> toJson() {
    return {
      'transfer_enabled': transferEnabled,
      'can_transfer_to_client': canTransferToClient,
      'can_pay_merchant': canPayMerchant,
    };
  }

  factory UpdateTransferRightsRequest.fromJson(Map<String, dynamic> json) {
    return UpdateTransferRightsRequest(
      transferEnabled: json['transfer_enabled'] as bool,
      canTransferToClient: json['can_transfer_to_client'] as bool,
      canPayMerchant: json['can_pay_merchant'] as bool,
    );
  }
}
