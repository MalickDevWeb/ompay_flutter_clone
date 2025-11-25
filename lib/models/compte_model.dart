class CompteModel {
  final String numeroCompte;
  final String titulaire;
  final double solde;
  final String statut;
  final String? codeMarchand;
  final String nomCompte;
  final String? qrCode;

  CompteModel({
    required this.numeroCompte,
    required this.titulaire,
    required this.solde,
    required this.statut,
    this.codeMarchand,
    required this.nomCompte,
    this.qrCode,
  });

  factory CompteModel.fromJson(Map<String, dynamic> json) {
    return CompteModel(
      numeroCompte: json['numero_compte']?.toString() ?? '',
      titulaire: json['titulaire']?.toString() ?? '',
      solde: (json['solde'] as num?)?.toDouble() ?? 0.0,
      statut: json['statut']?.toString() ?? '',
      codeMarchand: json['code_marchand']?.toString(),
      nomCompte: json['nom_compte']?.toString() ?? '',
      qrCode: json['qr_code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'numero_compte': numeroCompte,
    'titulaire': titulaire,
    'solde': solde,
    'statut': statut,
    'code_marchand': codeMarchand,
    'nom_compte': nomCompte,
    'qr_code': qrCode,
  };

  @override
  String toString() => 'CompteModel(numeroCompte: $numeroCompte, titulaire: $titulaire, solde: $solde, statut: $statut, nomCompte: $nomCompte)';
}

class ComptesResponse {
  final String status;
  final String message;
  final ComptesData data;

  ComptesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ComptesResponse.fromJson(Map<String, dynamic> json) {
    return ComptesResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: ComptesData.fromJson(json['data'] ?? {}),
    );
  }
}

class ComptesData {
  final int currentPage;
  final List<CompteModel> comptes;
  final int perPage;
  final int total;

  ComptesData({
    required this.currentPage,
    required this.comptes,
    required this.perPage,
    required this.total,
  });

  factory ComptesData.fromJson(Map<String, dynamic> json) {
    return ComptesData(
      currentPage: (json['current_page'] as int?) ?? 0,
      comptes: (json['data'] as List<dynamic>?)
          ?.map((item) => CompteModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      perPage: (json['per_page'] as int?) ?? 0,
      total: (json['total'] as int?) ?? 0,
    );
  }
}
