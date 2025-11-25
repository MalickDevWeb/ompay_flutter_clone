class TransactionModel {
  final String type;
  final double montant;
  final double? frais;
  final String reference;
  final String statut;
  final String? note;
  final DateTime dateTransaction;
  final String? numeroEnvoyer;
  final String? numeroRecepteur;

  TransactionModel({
    required this.type,
    required this.montant,
    this.frais,
    required this.reference,
    required this.statut,
    this.note,
    required this.dateTransaction,
    this.numeroEnvoyer,
    this.numeroRecepteur,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    try {
      final dateString = json['date_transaction']?.toString();
      if (dateString != null && dateString.isNotEmpty) {
        parsedDate = DateTime.parse(dateString);
      }
    } catch (e) {
      // If date parsing fails, use current time as fallback
      parsedDate = DateTime.now();
    }

    return TransactionModel(
      type: json['type']?.toString() ?? '',
      montant: (json['montant'] as num?)?.toDouble() ?? 0.0,
      frais: (json['frais'] as num?)?.toDouble(),
      reference: json['reference']?.toString() ?? '',
      statut: json['statut']?.toString() ?? '',
      note: json['note']?.toString(),
      dateTransaction: parsedDate ?? DateTime.now(),
      numeroEnvoyer: json['numero_envoyer']?.toString(),
      numeroRecepteur: json['numero_recepteur']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'montant': montant,
    'frais': frais,
    'reference': reference,
    'statut': statut,
    'note': note,
    'date_transaction': dateTransaction.toIso8601String(),
    'numero_envoyer': numeroEnvoyer,
    'numero_recepteur': numeroRecepteur,
  };

  @override
  String toString() => 'TransactionModel(type: $type, montant: $montant, reference: $reference, statut: $statut)';
}
