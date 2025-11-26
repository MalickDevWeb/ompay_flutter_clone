class BalancePurchaseRequest {
  final double montant;
  final String telephoneAdmin;

  BalancePurchaseRequest({
    required this.montant,
    required this.telephoneAdmin,
  });

  Map<String, dynamic> toJson() => {
    'montant': montant,
    'telephone_admin': telephoneAdmin,
  };
}
