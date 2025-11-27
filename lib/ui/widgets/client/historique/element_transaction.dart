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
    final amount = '${isPositive ? '+' : '-'}${transaction.montant.abs().toStringAsFixed(0)} CFA';
    final date = '${transaction.dateTransaction.day.toString().padLeft(2, '0')}/${transaction.dateTransaction.month.toString().padLeft(2, '0')} ${transaction.dateTransaction.hour.toString().padLeft(2, '0')}:${transaction.dateTransaction.minute.toString().padLeft(2, '0')}';
    final icon = transaction.type.contains('Transfert') ? Icons.swap_horiz : transaction.type.contains('Retrait') ? Icons.account_balance_wallet : Icons.phone_android;

    return Container(
      margin: EdgeInsets.only(bottom: 8, left: padding, right: padding),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7900).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF7900),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.type,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transaction.compteRecepteur ?? transaction.compteEmetteur ?? 'N/A',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
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
