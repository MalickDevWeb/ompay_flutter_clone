class AdminUserActionRequest {
  final String action;
  final String? motifRejet;
  final double? montant;
  final String? note;

  AdminUserActionRequest({
    required this.action,
    this.motifRejet,
    this.montant,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'action': action,
    if (motifRejet != null) 'motif_rejet': motifRejet,
    if (montant != null) 'montant': montant,
    if (note != null) 'note': note,
  };
}
