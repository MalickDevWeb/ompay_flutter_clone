class RegisterRequest {
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String password;
  final String type;

  RegisterRequest({
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.password,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'email': email,
    'password': password,
    'type': type,
  };
}
