import 'package:flutter/material.dart';
import 'section_max_it.dart';
import 'en_tete_historique.dart';
import 'historique_vide.dart';
import 'liste_transactions.dart';

class HistoriqueTransactions extends StatelessWidget {
  final bool isDarkMode;
  final List<Map<String, dynamic>> transactions;

  const HistoriqueTransactions({
    super.key,
    required this.isDarkMode,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = isSmallScreen ? 16.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionMaxIt(isDarkMode: isDarkMode, padding: padding),
        const SizedBox(height: 24),
        EnTeteHistorique(isDarkMode: isDarkMode, padding: padding),
        transactions.isEmpty
            ? HistoriqueVide(isDarkMode: isDarkMode)
            : ListeTransactions(
                isDarkMode: isDarkMode,
                transactions: transactions,
                padding: padding,
              ),
      ],
    );
  }
}

class MaxItSection extends StatelessWidget {
  final bool isDarkMode;
  final double padding;

  const MaxItSection({
    super.key,
    required this.isDarkMode,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pour toute autre opération',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Semantics(
              label: 'Accéder à Max it pour d\'autres opérations',
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7900),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Max it',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(
                  'Accéder à Max it',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 16,
                ),
                onTap: () {
                  // Naviguer vers Max it
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryHeader extends StatelessWidget {
  final bool isDarkMode;
  final double padding;

  const HistoryHeader({
    super.key,
    required this.isDarkMode,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Historique',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Semantics(
            label: 'Rafraîchir l\'historique',
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Color(0xFFFF7900),
              ),
              onPressed: () {
                // Rafraîchir l'historique
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyHistoryWidget extends StatelessWidget {
  final bool isDarkMode;

  const EmptyHistoryWidget({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.cloud_outlined,
                size: 80,
                color: Colors.grey,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7900),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                right: 10,
                child: Icon(
                  Icons.search,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Vous n'avez pas encore de transaction Orange Money.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionListWidget extends StatelessWidget {
  final bool isDarkMode;
  final List<Map<String, dynamic>> transactions;
  final double padding;

  const TransactionListWidget({
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
        return TransactionItemWidget(
          transaction: transaction,
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}

class TransactionItemWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final bool isDarkMode;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            transaction['icon'],
            color: Colors.grey[700],
            size: 24,
          ),
        ),
        title: Text(
          transaction['type'],
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          transaction['subtitle'],
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              transaction['amount'],
              style: TextStyle(
                color: transaction['isPositive']
                    ? Colors.green
                    : Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              transaction['date'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
