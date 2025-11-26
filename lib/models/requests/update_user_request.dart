class UpdateUserRequest {
  final String? nom;
  final String? prenom;
  final String? email;

  UpdateUserRequest({
    this.nom,
    this.prenom,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      if (nom != null) 'nom': nom,
      if (prenom != null) 'prenom': prenom,
      if (email != null) 'email': email,
    };
  }

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequest(
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      email: json['email'] as String?,
    );
  }
}
