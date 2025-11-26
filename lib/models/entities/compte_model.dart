class CompteModel {
  final int? id;
  final String numeroCompte;
  final double solde;
  final String type;
  final int? utilisateurId;
  final String? codeMarchand;
  final Map<String, dynamic>? links;

  CompteModel({
    this.id,
    required this.numeroCompte,
    required this.solde,
    required this.type,
    this.utilisateurId,
    this.codeMarchand,
    this.links,
  });

  factory CompteModel.fromJson(Map<String, dynamic> json) {
    return CompteModel(
      id: json['id'] as int?,
      numeroCompte: json['numeroCompte']?.toString() ?? '',
      solde: (json['solde'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? '',
      utilisateurId: json['utilisateur_id'] as int?,
      codeMarchand: json['code_marchand']?.toString(),
      links: json['links'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'numeroCompte': numeroCompte,
    'solde': solde,
    'type': type,
    'utilisateur_id': utilisateurId,
    'code_marchand': codeMarchand,
    'links': links,
  };

  // Compatibility getters
  String get statut => type;
  String get nomCompte => numeroCompte;
  String get titulaire => utilisateurId?.toString() ?? '';

  @override
  String toString() => 'CompteModel(id: $id, numeroCompte: $numeroCompte, solde: $solde, type: $type, utilisateurId: $utilisateurId)';
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
