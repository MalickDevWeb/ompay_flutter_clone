import 'package:flutter/material.dart';
import 'modele_compte_utilisateur.dart';

// ========================================
// DIALOG POUR GÉRER LES COMPTES
// ========================================

class AccountManagerDialog extends StatelessWidget {
  final bool isDarkMode;
  final List<AccountModel> accounts;
  final Function(AccountModel) onAccountSelected;
  final Function() onCreateAccount;

  const AccountManagerDialog({
    super.key,
    required this.isDarkMode,
    required this.accounts,
    required this.onAccountSelected,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFF7900),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Gérer les comptes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Liste des comptes
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: account.isActive
                          ? const Color(0xFFFF7900)
                          : Colors.grey[300],
                      child: Text(
                        account.nomCompte[0].toUpperCase(),
                        style: TextStyle(
                          color: account.isActive ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      account.nomCompte,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: account.isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      account.id?.toString() ?? account.numeroCompte,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: account.isActive
                        ? const Icon(Icons.check_circle, color: Color(0xFFFF7900))
                        : null,
                    onTap: () {
                      onAccountSelected(account);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),

            // Bouton créer un compte
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Future.delayed(Duration.zero, () => onCreateAccount());
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Créer un nouveau compte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7900),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
