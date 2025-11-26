class SwitchAccountResponse {
  final String status;
  final String message;
  final SwitchAccountData? data;

  SwitchAccountResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory SwitchAccountResponse.fromJson(Map<String, dynamic> json) {
    return SwitchAccountResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? SwitchAccountData.fromJson(json['data']) : null,
    );
  }
}

class SwitchAccountData {
  final String numeroCompte;
  final String nomCompte;
  final String statut;

  SwitchAccountData({
    required this.numeroCompte,
    required this.nomCompte,
    required this.statut,
  });

  factory SwitchAccountData.fromJson(Map<String, dynamic> json) {
    return SwitchAccountData(
      numeroCompte: json['numero_compte']?.toString() ?? '',
      nomCompte: json['nom_compte']?.toString() ?? '',
      statut: json['statut']?.toString() ?? '',
    );
  }
}
