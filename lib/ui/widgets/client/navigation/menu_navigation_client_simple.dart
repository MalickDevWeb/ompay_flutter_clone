import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../services/login_service.dart';
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

        // Afficher le SnackBar de manière sécurisée
        Future.delayed(Duration.zero, () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Compte changé: ${account.nomCompte}'),
                backgroundColor: AppColors.primary,
              ),
            );
          }
        });
      } else {
        Future.delayed(Duration.zero, () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur lors du changement de compte: ${result.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    } catch (e) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _handleAccountCreated(AccountModel newAccount) {
    if (!mounted) return;

    setState(() {
      accounts.add(newAccount);
    });

    // Afficher le SnackBar de manière sécurisée
    Future.delayed(Duration.zero, () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte créé avec succès'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    });
  }

  void _showCreateAccountDialog() {
    if (!mounted) return;

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
    final loginService = Provider.of<LoginService>(context);
    final user = loginService.clientProfile;
    final activeAccount = loginService.clientAccounts.isNotEmpty
        ? loginService.clientAccounts.firstWhere(
            (compte) => compte.statut.toLowerCase() == 'actif',
            orElse: () => loginService.clientAccounts.first,
          )
        : null;

    return Drawer(
      backgroundColor: AppColors.surface(widget.isDarkMode),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          EnteteTiroirSimple(
            isDarkMode: widget.isDarkMode,
            user: user,
            activeAccount: activeAccount,
          ),
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
