class AdminVirtualPurchaseTransactionRequest {
  final double montant;
  final String? note;

  AdminVirtualPurchaseTransactionRequest({
    required this.montant,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'montant': montant,
    if (note != null) 'note': note,
  };
}
