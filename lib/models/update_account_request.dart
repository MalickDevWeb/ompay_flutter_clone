import 'compte_model.dart';

class UpdateAccountRequest {
  final String? titulaire;
  final String? codeMarchand;
  final String? statut;
  final String? nomCompte;

  UpdateAccountRequest({
    this.titulaire,
    this.codeMarchand,
    this.statut,
    this.nomCompte,
  });

  Map<String, dynamic> toJson() => {
    if (titulaire != null) 'titulaire': titulaire,
    if (codeMarchand != null) 'code_marchand': codeMarchand,
    if (statut != null) 'statut': statut,
    if (nomCompte != null) 'nom_compte': nomCompte,
  };
}

class UpdateAccountResponse {
  final String status;
  final String message;
  final CompteModel? data;

  UpdateAccountResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory UpdateAccountResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAccountResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? CompteModel.fromJson(json['data']) : null,
    );
  }
}
