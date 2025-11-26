class CreateUserRequest {
  final String nom;
  final String prenom;
  final String telephone;
  final String? email;
  final String type;

  CreateUserRequest({
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.email,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      if (email != null) 'email': email,
      'type': type,
    };
  }

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) {
    return CreateUserRequest(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String?,
      type: json['type'] as String,
    );
  }
}
