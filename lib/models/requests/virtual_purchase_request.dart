class VirtualPurchaseRequest {
  final double montant;
  final String numeroCompte;
  final String? note;

  VirtualPurchaseRequest({
    required this.montant,
    required this.numeroCompte,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'montant': montant,
    'numero_compte': numeroCompte,
    if (note != null) 'note': note,
  };
}
