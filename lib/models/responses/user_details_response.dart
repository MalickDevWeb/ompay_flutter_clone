import '../../models/entities/compte_model.dart';
import '../../models/entities/transaction_model.dart';

class UserDetailsResponse {
  final String nom;
  final String prenom;
  final String numero;
  final List<CompteModel> comptes;
  final CompteModel? compteActif;
  final double? soldeCompteActif;
  final List<TransactionModel> transactionsCompteActif;

  UserDetailsResponse({
    required this.nom,
    required this.prenom,
    required this.numero,
    required this.comptes,
    this.compteActif,
    this.soldeCompteActif,
    required this.transactionsCompteActif,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponse(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      numero: json['numero'] as String,
      comptes: (json['comptes'] as List<dynamic>?)
          ?.map((e) => CompteModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      compteActif: json['compte_actif'] != null
          ? CompteModel.fromJson(json['compte_actif'] as Map<String, dynamic>)
          : null,
      soldeCompteActif: json['solde_compte_actif'] != null
          ? (json['solde_compte_actif'] as num).toDouble()
          : null,
      transactionsCompteActif: (json['transactions_compte_actif'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'numero': numero,
      'comptes': comptes.map((e) => e.toJson()).toList(),
      'compte_actif': compteActif?.toJson(),
      'solde_compte_actif': soldeCompteActif,
      'transactions_compte_actif': transactionsCompteActif.map((e) => e.toJson()).toList(),
    };
  }
}
