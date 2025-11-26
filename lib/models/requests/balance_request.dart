class BalanceRequest {
  final double montant;
  final String? note;

  BalanceRequest({
    required this.montant,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'montant': montant,
    if (note != null) 'note': note,
  };
}
