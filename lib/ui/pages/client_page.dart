import 'package:flutter/material.dart';
import '../widgets/client/entete/en_tete_client.dart';
import '../widgets/client/paiement/formulaire_paiement.dart';
import '../widgets/client/historique/historique_transactions.dart';
import '../widgets/client/navigation/menu_navigation_client_simple.dart';
import '../theme/app_colors.dart';
import '../../services/login_service.dart';
import '../../models/entities/transaction_model.dart';
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

  List<TransactionModel> get _transactions => _loginService.clientTransactions;

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
                      loginService: _loginService,
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
