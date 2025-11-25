class UnifiedTransactionRequest {
  final double montant;
  final String telephoneRecepteur;

  UnifiedTransactionRequest({
    required this.montant,
    required this.telephoneRecepteur,
  });

  Map<String, dynamic> toJson() => {
    'montant': montant,
    'telephone_recepteur': telephoneRecepteur,
  };
}
