class CreateUserAccountResponse {
  final String numeroCompte;
  final String titulaire;
  final String nomCompte;
  final String? codeMarchand;
  final String statut;
  final double solde;
  final String? qrCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreateUserAccountResponse({
    required this.numeroCompte,
    required this.titulaire,
    required this.nomCompte,
    this.codeMarchand,
    required this.statut,
    required this.solde,
    this.qrCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateUserAccountResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserAccountResponse(
      numeroCompte: json['numero_compte']?.toString() ?? '',
      titulaire: json['titulaire']?.toString() ?? '',
      nomCompte: json['nom_compte']?.toString() ?? '',
      codeMarchand: json['code_marchand']?.toString(),
      statut: json['statut']?.toString() ?? '',
      solde: (json['solde'] as num?)?.toDouble() ?? 0.0,
      qrCode: json['qr_code']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'numero_compte': numeroCompte,
      'titulaire': titulaire,
      'nom_compte': nomCompte,
      'code_marchand': codeMarchand,
      'statut': statut,
      'solde': solde,
      'qr_code': qrCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
