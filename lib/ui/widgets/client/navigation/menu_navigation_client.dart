import 'package:flutter/material.dart';
import 'composants/entete_tiroir.dart';
import 'composants/interrupteur_theme.dart';
import 'composants/interrupteur_scanner.dart';
import 'composants/selecteur_langue.dart';
import 'composants/section_comptes.dart';
import 'composants/bouton_deconnexion.dart';
import 'composants/texte_version.dart';
import 'composants/modele_compte_utilisateur.dart';

class ClientDrawer extends StatefulWidget {
  final bool isDarkMode;
  final bool isScannerEnabled;
  final String selectedLanguage;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onScannerChanged;
  final VoidCallback onLogout;

  const ClientDrawer({
    super.key,
    required this.isDarkMode,
    required this.isScannerEnabled,
    required this.selectedLanguage,
    required this.onDarkModeChanged,
    required this.onScannerChanged,
    required this.onLogout,
  });

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
  late List<AccountModel> accounts;

  @override
  void initState() {
    super.initState();
    accounts = [
      AccountModel(
        numeroCompte: 'CPT-5556', // nom du compte pas le account holder
        nomCompte: 'Compte Epargne', // numéro compte pas le phone number
        isActive: true,
      ),
     AccountModel(
        numeroCompte: 'CPT-5557',
        nomCompte: 'Compte Courant',
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
        content: Text('Compte changé: ${account.nomCompte}'),
        backgroundColor: const Color(0xFFFF7900),
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
        backgroundColor: Color(0xFFFF7900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          EnteteTiroir(isDarkMode: widget.isDarkMode),
          InterrupteurTheme(
            isDarkMode: widget.isDarkMode,
            onDarkModeChanged: widget.onDarkModeChanged,
          ),
          InterrupteurScanner(
            isScannerEnabled: widget.isScannerEnabled,
            onScannerChanged: widget.onScannerChanged,
          ),
          SelecteurLangue(selectedLanguage: widget.selectedLanguage),
          const Divider(),
          SectionGestionComptes(
            isDarkMode: widget.isDarkMode,
            accounts: accounts,
            onAccountSelected: _handleAccountSelected,
            onAccountCreated: _handleAccountCreated,
          ),
          const Divider(),
          BoutonDeconnexion(
            isDarkMode: widget.isDarkMode,
            onLogout: widget.onLogout,
          ),
          TexteVersion(isDarkMode: widget.isDarkMode),
        ],
      ),
    );
  }
}
