class AdminVirtualPurchaseRequest {
  final String userId;
  final double montant;
  final String? note;

  AdminVirtualPurchaseRequest({
    required this.userId,
    required this.montant,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'montant': montant,
    if (note != null) 'note': note,
  };
}
