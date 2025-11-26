class WithdrawalRequest {
  final double montant;
  final String telephoneEmetteur;
  final String? note;

  WithdrawalRequest({
    required this.montant,
    required this.telephoneEmetteur,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'montant': montant,
    'telephone_emetteur': telephoneEmetteur,
    if (note != null) 'note': note,
  };
}
