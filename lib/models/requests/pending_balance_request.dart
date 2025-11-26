import '../entities/user_model.dart';

class PendingBalanceRequest {
  final String id;
  final UserModel supplier;
  final double montant;
  final String statut;

  PendingBalanceRequest({
    required this.id,
    required this.supplier,
    required this.montant,
    required this.statut,
  });

  factory PendingBalanceRequest.fromJson(Map<String, dynamic> json) {
    return PendingBalanceRequest(
      id: json['id'] as String,
      supplier: UserModel.fromJson(json['supplier'] as Map<String, dynamic>),
      montant: (json['montant'] as num).toDouble(),
      statut: json['statut'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier': supplier.toJson(),
      'montant': montant,
      'statut': statut,
    };
  }
}
