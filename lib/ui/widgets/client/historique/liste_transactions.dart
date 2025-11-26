import 'package:flutter/material.dart';
import 'element_transaction.dart';

class ListeTransactions extends StatelessWidget {
  final bool isDarkMode;
  final List<Map<String, dynamic>> transactions;
  final double padding;

  const ListeTransactions({
    super.key,
    required this.isDarkMode,
    required this.transactions,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ElementTransaction(
          transaction: transaction,
          isDarkMode: isDarkMode,
          padding: padding,
        );
      },
    );
  }
}
