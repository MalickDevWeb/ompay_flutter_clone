class AdminBalanceRequestActionRequest {
  final String action;
  final String? motifRejet;

  AdminBalanceRequestActionRequest({
    required this.action,
    this.motifRejet,
  });

  Map<String, dynamic> toJson() => {
    'action': action,
    if (motifRejet != null) 'motif_rejet': motifRejet,
  };
}
