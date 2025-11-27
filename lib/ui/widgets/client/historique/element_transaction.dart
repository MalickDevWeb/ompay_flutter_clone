import 'package:flutter/material.dart';
import '../../../../models/entities/transaction_model.dart';

class ElementTransaction extends StatelessWidget {
  final TransactionModel transaction;
  final bool isDarkMode;
  final double padding;

  const ElementTransaction({
    super.key,
    required this.transaction,
    required this.isDarkMode,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.montant > 0;
    final amount = '${isPositive ? '+' : '-'}${transaction.montant.abs().toStringAsFixed(0)}';
    final date = '${transaction.dateTransaction.day.toString().padLeft(2, '0')}/${transaction.dateTransaction.month.toString().padLeft(2, '0')} ${transaction.dateTransaction.hour.toString().padLeft(2, '0')}:${transaction.dateTransaction.minute.toString().padLeft(2, '0')}';
    final icon = transaction.type.contains('Transfert') ? Icons.swap_horiz : transaction.type.contains('Retrait') ? Icons.account_balance_wallet : Icons.phone_android;

    // Determine the label based on transaction type (matching React example)
    String label = '';
    if (transaction.type.contains('Transfert')) {
      label = "Transfert d'argent";
    } else if (transaction.type.contains('Retrait') || transaction.type.contains('depot')) {
      label = transaction.type;
    } else if (transaction.type.contains('Paiement')) {
      label = 'Paiement marchand';
    } else {
      label = transaction.type;
    }

    // Use transaction reference as the secondary text (matching React example)
    final secondaryText = transaction.reference.isNotEmpty ? transaction.reference : 'N/A';

    return Container(
      margin: EdgeInsets.only(bottom: 12, left: padding, right: padding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: !isDarkMode
            ? [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                Text(
                  secondaryText,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (amount.isNotEmpty)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: amount,
                        style: TextStyle(
                          color: isPositive ? Colors.green[400] : (isDarkMode ? Colors.white : Colors.black),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: ' CFA',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                date,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
