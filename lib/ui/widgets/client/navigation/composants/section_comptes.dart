// ========================================
// SECTION GESTION DES COMPTES
// ========================================

import 'package:flutter/material.dart';
import 'dialogue_gestion_comptes.dart';
import 'dialogue_creation_nouveau_compte.dart';
import 'modele_compte_utilisateur.dart';

class SectionGestionComptes extends StatelessWidget {
  final bool isDarkMode;
  final List<AccountModel> accounts;
  final Function(AccountModel) onAccountSelected;
  final Function(AccountModel) onAccountCreated;

  const SectionGestionComptes({
    super.key,
    required this.isDarkMode,
    required this.accounts,
    required this.onAccountSelected,
    required this.onAccountCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Gestion des comptes',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TuileChangerCompte(
          isDarkMode: isDarkMode,
          accounts: accounts,
          onAccountSelected: onAccountSelected,
          onCreateAccount: () => _showCreateAccountDialog(context),
        ),
        TuileCreerCompte(
          isDarkMode: isDarkMode,
          onAccountCreated: onAccountCreated,
        ),
      ],
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DialogueCreationNouveauCompte(
        isDarkMode: isDarkMode,
        onAccountCreated: onAccountCreated,
      ),
    );
  }
}

class TuileChangerCompte extends StatelessWidget {
  final bool isDarkMode;
  final List<AccountModel> accounts;
  final Function(AccountModel) onAccountSelected;
  final VoidCallback onCreateAccount;

  const TuileChangerCompte({
    super.key,
    required this.isDarkMode,
    required this.accounts,
    required this.onAccountSelected,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFFFF7900).withValues(alpha: 0.2)
              : const Color(0xFFFF7900).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.swap_horiz,
          color: isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      title: Text(
        'Changer de compte',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Sélectionner un autre compte',
        style: TextStyle(
          color: isDarkMode ? Colors.white60 : Colors.black54,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isDarkMode ? Colors.white60 : Colors.black54,
        size: 16,
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AccountManagerDialog(
            isDarkMode: isDarkMode,
            accounts: accounts,
            onAccountSelected: onAccountSelected,
            onCreateAccount: onCreateAccount,
          ),
        );
      },
    );
  }
}

class TuileCreerCompte extends StatelessWidget {
  final bool isDarkMode;
  final Function(AccountModel) onAccountCreated;

  const TuileCreerCompte({
    super.key,
    required this.isDarkMode,
    required this.onAccountCreated,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF4CAF50).withValues(alpha: 0.2)
              : const Color(0xFF4CAF50).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_circle,
          color: isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      title: Text(
        'Créer un nouveau compte',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Ajouter un compte supplémentaire',
        style: TextStyle(
          color: isDarkMode ? Colors.white60 : Colors.black54,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isDarkMode ? Colors.white60 : Colors.black54,
        size: 16,
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => DialogueCreationNouveauCompte(
            isDarkMode: isDarkMode,
            onAccountCreated: onAccountCreated,
          ),
        );
      },
    );
  }
}
