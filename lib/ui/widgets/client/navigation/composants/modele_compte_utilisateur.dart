// ========================================
// MODÈLE DE COMPTE UTILISATEUR
// ========================================

class AccountModel {
  final String id;
  final String nom;
  final String telephone;
  final String solde;
  bool isActive;

  AccountModel({
    required this.id,
    required this.nom,
    this.telephone = '',
    this.solde = '0',
    this.isActive = false,
  });
}
