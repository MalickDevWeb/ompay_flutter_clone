class TransactionModel {
  final int? id;
  final String type;
  final double montant;
  final String? compteEmetteur;
  final String? compteRecepteur;
  final DateTime dateTransaction;
  final String statut;
  final Map<String, dynamic>? links;

  TransactionModel({
    this.id,
    required this.type,
    required this.montant,
    this.compteEmetteur,
    this.compteRecepteur,
    required this.dateTransaction,
    required this.statut,
    this.links,
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

    // Handle montant parsing - can be num or string (e.g., "+50000.00")
    double montant = 0.0;
    final montantValue = json['montant'];
    if (montantValue != null) {
      if (montantValue is num) {
        montant = montantValue.toDouble();
      } else if (montantValue is String) {
        // Remove any non-numeric characters except decimal point and minus sign
        final cleanedString = montantValue.replaceAll(RegExp(r'[^\d.-]'), '');
        montant = double.tryParse(cleanedString) ?? 0.0;
      }
    }

    return TransactionModel(
      id: json['id'] as int?,
      type: json['type']?.toString() ?? '',
      montant: montant,
      compteEmetteur: json['compte_emetteur']?.toString(),
      compteRecepteur: json['compte_recepteur']?.toString(),
      dateTransaction: parsedDate ?? DateTime.now(),
      statut: json['statut']?.toString() ?? '',
      links: json['links'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'montant': montant,
    'compte_emetteur': compteEmetteur,
    'compte_recepteur': compteRecepteur,
    'date_transaction': dateTransaction.toIso8601String(),
    'statut': statut,
    'links': links,
  };

  // Compatibility getter
  String get reference => id?.toString() ?? '';

  @override
  String toString() => 'TransactionModel(id: $id, type: $type, montant: $montant, statut: $statut)';
}
