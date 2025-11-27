import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../services/login_service.dart';
import '../../../../../models/entities/compte_model.dart';
import '../../../../../models/entities/user_model.dart';
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
    // Initialize with empty list - will be populated from LoginService
    accounts = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load accounts from LoginService when dependencies change
    _loadAccountsFromLoginService();
  }

  void _loadAccountsFromLoginService() {
    final loginService = Provider.of<LoginService>(context, listen: false);
    final comptes = loginService.clientAccounts;

    setState(() {
      accounts = comptes.map((compte) => AccountModel(
        id: compte.id,
        numeroCompte: compte.numeroCompte,
        nomCompte: compte.nomCompte ?? 'Compte ${compte.numeroCompte}',
        isActive: compte.statut.toLowerCase() == 'actif',
      )).toList();
    });
  }

  Future<void> _handleAccountSelected(AccountModel account) async {
    try {
      final loginService = Provider.of<LoginService>(context, listen: false);

      // Call API to switch account
      final result = await loginService.userService.switchActiveAccount(account.numeroCompte);

      if (result.isSuccess) {
        // Update local state
        setState(() {
          for (var acc in accounts) {
            acc.isActive = false;
          }
          account.isActive = true;
        });

        // Reload user data to get updated balance and transactions
        _loadAccountsFromLoginService();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Compte changé: ${account.nomCompte}'),
            backgroundColor: const Color(0xFFFF7900),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du changement de compte: ${result.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleAccountCreated(AccountModel newAccount) async {
    try {
      final loginService = Provider.of<LoginService>(context, listen: false);

      // Call API to create account - Note: This would need to be implemented
      // For now, just show a message that creation is not implemented
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Création de compte - Fonctionnalité à implémenter'),
          backgroundColor: Colors.orange,
        ),
      );

      // TODO: Implement account creation API call
      // final result = await loginService.userService.createAccount(...);
      // if (result.isSuccess) {
      //   _loadAccountsFromLoginService();
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Compte créé avec succès'),
      //       backgroundColor: Color(0xFFFF7900),
      //     ),
      //   );
      // }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<LoginService>(context);
    final user = loginService.clientProfile;

    return Drawer(
      backgroundColor: widget.isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          EnteteTiroir(isDarkMode: widget.isDarkMode, user: user),
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
