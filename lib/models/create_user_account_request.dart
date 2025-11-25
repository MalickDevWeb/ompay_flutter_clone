class CreateUserAccountRequest {
  final String nomCompte;

  CreateUserAccountRequest({
    required this.nomCompte,
  }) : assert(nomCompte.trim().isNotEmpty, 'nomCompte cannot be empty');

  factory CreateUserAccountRequest.fromJson(Map<String, dynamic> json) {
    final nomCompte = json['nom_compte']?.toString() ?? '';
    if (nomCompte.trim().isEmpty) {
      throw ArgumentError('nomCompte cannot be empty');
    }
    return CreateUserAccountRequest(
      nomCompte: nomCompte,
    );
  }

  Map<String, dynamic> toJson() => {
    'nom_compte': nomCompte.trim(),
  };

  @override
  String toString() => 'CreateUserAccountRequest(nomCompte: $nomCompte)';
}
