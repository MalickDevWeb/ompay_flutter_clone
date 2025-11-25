class DepositRequest {
  final double montant;
  final String telephoneRecepteurId;
  final String? note;

  DepositRequest({
    required this.montant,
    required this.telephoneRecepteurId,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'montant': montant,
    'telephone_recepteur_id': telephoneRecepteurId,
    if (note != null) 'note': note,
  };
}
