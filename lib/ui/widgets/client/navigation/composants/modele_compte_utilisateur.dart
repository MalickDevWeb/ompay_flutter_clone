// ========================================
// MODÈLE DE COMPTE UTILISATEUR
// ========================================

class AccountModel {
  final int? id;
  final String nomCompte;
  final String numeroCompte;
  bool isActive;

  AccountModel({
    this.id,
    required this.numeroCompte,
    required this.nomCompte,
    this.isActive = false,
  });
}
