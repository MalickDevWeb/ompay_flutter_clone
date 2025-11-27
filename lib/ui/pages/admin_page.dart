import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_flutter/ui/widgets/admin/entete_admin.dart';
import 'package:test_flutter/services/communication/dio_client.dart';
import 'package:test_flutter/ui/widgets/admin/tiroir_admin.dart';
import 'package:test_flutter/ui/widgets/admin/admin_tab_bar_view.dart';
import 'package:test_flutter/data/mock/admin_page_mock_data.dart';
import 'package:test_flutter/ui/widgets/admin/tax_dialog.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDarkMode = true;
  late TabController _tabController;
  String? _apiTestResult;
  bool _showApiTestDialog = false;

  late List<Map<String, dynamic>> _pendingUsers;
  late List<Map<String, dynamic>> _balanceRequests;
  late List<Map<String, dynamic>> _activeClients;

  // Frais globaux
  double _transferFee = 2.5;
  double _withdrawalFee = 1.5;
  double _paymentFee = 0.5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pendingUsers = List.from(pendingUsers);
    _balanceRequests = List.from(balanceRequests);
    _activeClients = List.from(activeClients);
  }

  DioClient get _dioClient => DioClient();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Méthode pour tester la connexion à l'API
  Future<void> _testApiConnection() async {
    try {
      final result = await _dioClient.get('/status');
      if (!mounted) return;
      setState(() {
        _apiTestResult = result.isSuccess ? 'Succès: ${result.data}' : 'Erreur: ${result.error}';
        _showApiTestDialog = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _apiTestResult = 'Erreur de connexion: $e';
        _showApiTestDialog = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[100],
      drawer: TiroirAdmin(
        isDarkMode: _isDarkMode,
        onToggleDarkMode: () => setState(() => _isDarkMode = !_isDarkMode),
        onLogout: _onLogout,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // En-tête de l'administration avec onglets
          EnteteAdmin(
            isDarkMode: _isDarkMode,
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            tabController: _tabController,
          ),
        ],
        body: AdminTabBarView(
          tabController: _tabController,
          isDarkMode: _isDarkMode,
          pendingUsers: _pendingUsers,
          balanceRequests: _balanceRequests,
          activeClients: _activeClients,
          transferFee: _transferFee,
          withdrawalFee: _withdrawalFee,
          paymentFee: _paymentFee,
          onApproveUser: _approveUser,
          onRejectUser: _rejectUser,
          onApproveBalanceRequest: _approveBalanceRequest,
          onRejectBalanceRequest: _rejectBalanceRequest,
          onToggleBanClient: _toggleBanClient,
          onShowTaxDialog: _showTaxDialog,
          onTransferFeeChanged: (value) => setState(() => _transferFee = value),
          onWithdrawalFeeChanged: (value) => setState(() => _withdrawalFee = value),
          onPaymentFeeChanged: (value) => setState(() => _paymentFee = value),
          onSaveFees: _saveGlobalFees,
          pendingUsersCount: _pendingUsers.length,
          onTestApi: _testApiConnection,
          showApiTestDialog: _showApiTestDialog,
          apiTestResult: _apiTestResult,
          onCloseApiTestDialog: () => setState(() {
            _showApiTestDialog = false;
            _apiTestResult = null;
          }),
        ),
      ),
    );
  }

  // Méthodes de gestion des utilisateurs et demandes
  void _approveUser(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user['nom']} approuvé'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() => _pendingUsers.remove(user));
  }

  void _rejectUser(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user['nom']} rejeté'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() => _pendingUsers.remove(user));
  }

  void _approveBalanceRequest(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demande de ${request['nom']} approuvée'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() => _balanceRequests.remove(request));
  }

  void _rejectBalanceRequest(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demande de ${request['nom']} rejetée'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() => _balanceRequests.remove(request));
  }

  void _toggleBanClient(int index) {
    setState(() {
      _activeClients[index]['isBanned'] = !_activeClients[index]['isBanned'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _activeClients[index]['isBanned'] ? 'Client banni' : 'Client débanni',
        ),
        backgroundColor: _activeClients[index]['isBanned']
            ? Colors.red
            : Colors.green,
      ),
    );
  }

  void _showTaxDialog(Map<String, dynamic> client) {
    showDialog(
      context: context,
      builder: (context) => TaxDialog(
        client: client,
        isDarkMode: _isDarkMode,
        onApply: (tax) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Taxe de $tax% appliquée'),
              backgroundColor: const Color(0xFFFF7900),
            ),
          );
        },
      ),
    );
  }

  void _saveGlobalFees() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Frais globaux sauvegardés avec succès'),
        backgroundColor: Color(0xFFFF7900),
      ),
    );
  }

  void _onLogout() {
    // Naviguer vers la page de connexion
    context.go('/login');
  }
}
