class PendingUser {
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String type;
  final String statut;
  final String pin;

  PendingUser({
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.type,
    required this.statut,
    required this.pin,
  });

  factory PendingUser.fromJson(Map<String, dynamic> json) {
    return PendingUser(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String,
      type: json['type'] as String,
      statut: json['statut'] as String,
      pin: json['pin'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'type': type,
      'statut': statut,
      'pin': pin,
    };
  }
}
