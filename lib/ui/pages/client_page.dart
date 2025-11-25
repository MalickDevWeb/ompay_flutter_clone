import 'package:flutter/material.dart';
import 'package:test_flutter/ui/widgets/client/client_header.dart';
import 'package:test_flutter/ui/widgets/client/payment_form.dart';
import 'package:test_flutter/ui/widgets/client/max_it_section.dart';
import 'package:test_flutter/ui/widgets/client/history_section.dart';
import 'package:test_flutter/ui/widgets/client/client_drawer.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPayerSelected = true;
  bool _isSoldeVisible = false;
  bool _isDarkMode = true;
  bool _isScannerEnabled = true;
  String _selectedLanguage = 'Français';

  // Données fictives pour l'historique
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'Transfert d\'argent',
      'subtitle': 'Djeuli ODC',
      'amount': '- 2 CFA',
      'date': '17/11 16:49',
      'icon': Icons.phone_android,
      'isPositive': false,
    },
    {
      'type': 'Retrait d\'argent',
      'subtitle': '786284027',
      'amount': '- 20 000 CFA',
      'date': '11/11 20:01',
      'icon': Icons.account_balance_wallet,
      'isPositive': false,
    },
    {
      'type': 'Retrait d\'argent',
      'subtitle': '786284027',
      'amount': '+ 20 000 CFA',
      'date': '10/11 15:30',
      'icon': Icons.account_balance_wallet,
      'isPositive': true,
    },
  ];

  @override
  void dispose() {
    _numeroController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  // Méthode appelée lors du changement d'onglet (Payer/Transférer)
  void _onTabChanged(bool value) {
    setState(() {
      _isPayerSelected = value;
    });
  }

  // Méthode appelée lors de la validation du paiement
  void _onValidate() {
    if (_numeroController.text.isEmpty || _montantController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Traiter la transaction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPayerSelected ? 'Paiement en cours...' : 'Transfert en cours...',
        ),
        backgroundColor: const Color(0xFFFF7900),
      ),
    );
  }

  // Méthode appelée lors du changement de mode sombre
  void _onDarkModeChanged(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  // Méthode appelée lors du changement du scanner
  void _onScannerChanged(bool value) {
    setState(() {
      _isScannerEnabled = value;
    });
  }

  // Méthode appelée lors du rafraîchissement de l'historique
  void _onRefreshHistory() {
    setState(() {
      // Rafraîchir l'historique
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[100],
      drawer: ClientDrawer(
        isDarkMode: _isDarkMode,
        isScannerEnabled: _isScannerEnabled,
        selectedLanguage: _selectedLanguage,
        onDarkModeChanged: _onDarkModeChanged,
        onScannerChanged: _onScannerChanged,
      ),
      body: CustomScrollView(
        slivers: [
          // Header du client avec solde et QR code
          ClientHeader(
            isDarkMode: _isDarkMode,
            isSoldeVisible: _isSoldeVisible,
            onToggleSolde: () {
              setState(() {
                _isSoldeVisible = !_isSoldeVisible;
              });
            },
          ),

          // Contenu principal avec sections
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Formulaire de paiement avec onglets et champs
                PaymentForm(
                  isDarkMode: _isDarkMode,
                  isPayerSelected: _isPayerSelected,
                  onTabChanged: _onTabChanged,
                  numeroController: _numeroController,
                  montantController: _montantController,
                  onValidate: _onValidate,
                ),

                const SizedBox(height: 24),

                // Section pour accéder à Max it
                MaxItSection(isDarkMode: _isDarkMode),

                const SizedBox(height: 24),

                // Section historique des transactions
                HistorySection(
                  isDarkMode: _isDarkMode,
                  transactions: _transactions,
                  onRefresh: _onRefreshHistory,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
