class ActiveClient {
  final String nom;
  final String telephone;
  final String solde;
  final String statut;
  final bool isBanned;

  ActiveClient({
    required this.nom,
    required this.telephone,
    required this.solde,
    required this.statut,
    required this.isBanned,
  });

  factory ActiveClient.fromJson(Map<String, dynamic> json) {
    return ActiveClient(
      nom: json['nom'] as String,
      telephone: json['telephone'] as String,
      solde: json['solde'] as String,
      statut: json['statut'] as String,
      isBanned: json['isBanned'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'telephone': telephone,
      'solde': solde,
      'statut': statut,
      'isBanned': isBanned,
    };
  }
}
