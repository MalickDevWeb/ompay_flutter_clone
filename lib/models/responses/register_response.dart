class RegisterResponse {
  final UserData user;
  final String message;
  final String redirectUrl;

  RegisterResponse({
    required this.user,
    required this.message,
    required this.redirectUrl,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: UserData.fromJson(json['user']),
      message: json['message'],
      redirectUrl: json['redirect_url'],
    );
  }
}

class UserData {
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String type;
  final String statut;

  UserData({
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.type,
    required this.statut,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      email: json['email'],
      type: json['type'],
      statut: json['statut'],
    );
  }
}
