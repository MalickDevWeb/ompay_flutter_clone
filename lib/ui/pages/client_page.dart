import 'package:flutter/material.dart';
import '../widgets/client/entete/en_tete_client.dart';
import '../widgets/client/paiement/formulaire_paiement.dart';
import '../widgets/client/historique/historique_transactions.dart';
import '../widgets/client/navigation/menu_navigation_client_simple.dart';
import '../theme/app_colors.dart';
import '../../services/login_service.dart';
import 'package:provider/provider.dart';

class ClientPageWithQR extends StatefulWidget {
  const ClientPageWithQR({super.key});

  @override
  State<ClientPageWithQR> createState() => _ClientPageWithQRState();
}

class _ClientPageWithQRState extends State<ClientPageWithQR> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPayerSelected = true;
  bool _isSoldeVisible = false;
  bool _isDarkMode = true;

  late LoginService _loginService;

  @override
  void initState() {
    super.initState();
    _loginService = context.read<LoginService>();
  }

  // No need for _loadClientData, data is loaded in LoginService

  List<Map<String, dynamic>> get _transactions {
    final transactions = _loginService.clientTransactions;
    if (transactions == null || transactions.isEmpty) {
      return [];
    }

    return transactions.map((transaction) {
      return {
        'type': transaction.type.isNotEmpty ? transaction.type : 'Transaction',
        'subtitle': transaction.reference.isNotEmpty ? transaction.reference : 'N/A',
        'amount': '${transaction.montant > 0 ? '+' : ''}${transaction.montant} CFA',
        'date': _formatDate(transaction.dateTransaction),
        'icon': _getTransactionIcon(transaction.type),
        'isPositive': transaction.montant > 0,
      };
    }).toList();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  IconData _getTransactionIcon(String? type) {
    if (type == null) return Icons.swap_horiz;

    final lowerType = type.toLowerCase();
    if (lowerType.contains('depot') || lowerType.contains('deposit')) {
      return Icons.account_balance_wallet;
    } else if (lowerType.contains('retrait') || lowerType.contains('withdrawal')) {
      return Icons.account_balance_wallet;
    } else if (lowerType.contains('transfert') || lowerType.contains('transfer')) {
      return Icons.phone_android;
    }
    return Icons.swap_horiz;
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loginService,
      builder: (context, child) {
        if (_loginService.isDataLoading) {
          return Scaffold(
            backgroundColor: AppColors.background(_isDarkMode),
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background(_isDarkMode),
          drawer: MenuNavigationClientSimple(
            isDarkMode: _isDarkMode,
            onThemeChanged: (value) => setState(() => _isDarkMode = value),
          ),
          body: CustomScrollView(
            slivers: [
              EnTeteClient(
                isDarkMode: _isDarkMode,
                isSoldeVisible: _isSoldeVisible,
                onToggleSolde: () => setState(() => _isSoldeVisible = !_isSoldeVisible),
                userName: _loginService.clientProfile?.prenom ?? 'Utilisateur',
                balance: _loginService.clientBalance,
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    FormulairePaiement(
                      isDarkMode: _isDarkMode,
                      isPayerSelected: _isPayerSelected,
                      onTabChanged: (value) => setState(() => _isPayerSelected = value),
                      numeroController: _numeroController,
                      montantController: _montantController,
                      onValidate: () {},
                    ),

                    HistoriqueTransactions(
                      isDarkMode: _isDarkMode,
                      transactions: _transactions,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
