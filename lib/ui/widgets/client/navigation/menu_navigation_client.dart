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
