// ========================================
// SECTION GESTION DES COMPTES SIMPLE
// ========================================

import 'package:flutter/material.dart';
import 'dialogue_gestion_comptes.dart';
import 'dialogue_creation_nouveau_compte.dart';
import 'modele_compte_utilisateur.dart';
import '../../../../theme/app_colors.dart';

class SectionGestionComptesSimple extends StatelessWidget {
  final bool isDarkMode;
  final List<AccountModel> accounts;
  final Function(AccountModel) onAccountSelected;
  final Function(AccountModel) onAccountCreated;
  final VoidCallback onCreateAccountPressed;

  const SectionGestionComptesSimple({
    super.key,
    required this.isDarkMode,
    required this.accounts,
    required this.onAccountSelected,
    required this.onAccountCreated,
    required this.onCreateAccountPressed,
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
              color: AppColors.textSecondary(isDarkMode),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TuileChangerCompteSimple(
          isDarkMode: isDarkMode,
          accounts: accounts,
          onAccountSelected: onAccountSelected,
          onCreateAccountPressed: onCreateAccountPressed,
        ),
        TuileCreerCompteSimple(
          isDarkMode: isDarkMode,
          onAccountCreated: onAccountCreated,
        ),
      ],
    );
  }
}

class TuileChangerCompteSimple extends StatelessWidget {
  final bool isDarkMode;
  final List<AccountModel> accounts;
  final Function(AccountModel) onAccountSelected;
  final VoidCallback onCreateAccountPressed;

  const TuileChangerCompteSimple({
    super.key,
    required this.isDarkMode,
    required this.accounts,
    required this.onAccountSelected,
    required this.onCreateAccountPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.swap_horiz,
          color: AppColors.icon(isDarkMode),
          size: 20,
        ),
      ),
      title: Text(
        'Changer de compte',
        style: TextStyle(
          color: AppColors.textPrimary(isDarkMode),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Sélectionner un autre compte',
        style: TextStyle(
          color: AppColors.textSecondary(isDarkMode),
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.iconSecondary(isDarkMode),
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
            onCreateAccount: onCreateAccountPressed,
          ),
        );
      },
    );
  }
}

class TuileCreerCompteSimple extends StatelessWidget {
  final bool isDarkMode;
  final Function(AccountModel) onAccountCreated;

  const TuileCreerCompteSimple({
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
              ? AppColors.secondary.withValues(alpha: 0.2)
              : AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_circle,
          color: AppColors.icon(isDarkMode),
          size: 20,
        ),
      ),
      title: Text(
        'Créer un nouveau compte',
        style: TextStyle(
          color: AppColors.textPrimary(isDarkMode),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Ajouter un compte supplémentaire',
        style: TextStyle(
          color: AppColors.textSecondary(isDarkMode),
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.iconSecondary(isDarkMode),
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
