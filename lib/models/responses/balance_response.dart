class BalanceResponse {
  final String status;
  final String message;
  final BalanceData data;

  BalanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: BalanceData.fromJson(json['data'] ?? {}),
    );
  }
}

class BalanceData {
  final double solde;
  final String numeroCompte;
  final String nomCompte;

  BalanceData({
    required this.solde,
    required this.numeroCompte,
    required this.nomCompte,
  });

  factory BalanceData.fromJson(Map<String, dynamic> json) {
    return BalanceData(
      solde: (json['solde'] as num?)?.toDouble() ?? 0.0,
      numeroCompte: json['numero_compte']?.toString() ?? '',
      nomCompte: json['nom_compte']?.toString() ?? '',
    );
  }
}
