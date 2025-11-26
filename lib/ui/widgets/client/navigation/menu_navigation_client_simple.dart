import 'package:flutter/material.dart';
import 'composants/entete_tiroir_simple.dart';
import 'composants/interrupteur_theme_simple.dart';
import 'composants/section_comptes_simple.dart';
import 'composants/bouton_deconnexion_simple.dart';
import 'composants/texte_version_simple.dart';
import 'composants/dialogue_creation_nouveau_compte.dart';
import 'composants/modele_compte_utilisateur.dart';
import '../../../theme/app_colors.dart';

class MenuNavigationClientSimple extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MenuNavigationClientSimple({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MenuNavigationClientSimple> createState() => _MenuNavigationClientSimpleState();
}

class _MenuNavigationClientSimpleState extends State<MenuNavigationClientSimple> {
  late List<AccountModel> accounts;

  @override
  void initState() {
    super.initState();
    accounts = [
      AccountModel(
        id: '1',
        nom: 'Abdoulaye Diallo',
        telephone: '782917770',
        solde: '50000',
        isActive: true,
      ),
      AccountModel(
        id: '2',
        nom: 'Djeuli ODC',
        telephone: '786284027',
        solde: '120000',
        isActive: false,
      ),
    ];
  }

  void _handleAccountSelected(AccountModel account) {
    setState(() {
      for (var acc in accounts) {
        acc.isActive = false;
      }
      account.isActive = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compte changé: ${account.nom}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleAccountCreated(AccountModel newAccount) {
    setState(() {
      accounts.add(newAccount);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compte créé avec succès'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showCreateAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => DialogueCreationNouveauCompte(
        isDarkMode: widget.isDarkMode,
        onAccountCreated: _handleAccountCreated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface(widget.isDarkMode),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          EnteteTiroirSimple(isDarkMode: widget.isDarkMode),
          InterrupteurThemeSimple(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
          const Divider(),
          SectionGestionComptesSimple(
            isDarkMode: widget.isDarkMode,
            accounts: accounts,
            onAccountSelected: _handleAccountSelected,
            onAccountCreated: _handleAccountCreated,
            onCreateAccountPressed: _showCreateAccountDialog,
          ),
          const Divider(),
          BoutonDeconnexionSimple(isDarkMode: widget.isDarkMode),
          TexteVersionSimple(isDarkMode: widget.isDarkMode),
        ],
      ),
    );
  }
}
