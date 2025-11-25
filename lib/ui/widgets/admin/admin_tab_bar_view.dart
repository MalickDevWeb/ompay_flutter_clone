import 'package:flutter/material.dart';
import 'package:test_flutter/ui/widgets/admin/onglet_approbations_admin.dart';
import 'package:test_flutter/ui/widgets/admin/onglet_clients_admin.dart';
import 'package:test_flutter/ui/widgets/admin/onglet_frais_admin.dart';
import 'package:test_flutter/ui/widgets/admin/onglet_stats_admin.dart';
import 'package:test_flutter/ui/widgets/admin/api_test_dialog.dart';

class AdminTabBarView extends StatelessWidget {
  final TabController tabController;
  final bool isDarkMode;
  final List<Map<String, dynamic>> pendingUsers;
  final List<Map<String, dynamic>> balanceRequests;
  final List<Map<String, dynamic>> activeClients;
  final double transferFee;
  final double withdrawalFee;
  final double paymentFee;
  final Function(Map<String, dynamic>) onApproveUser;
  final Function(Map<String, dynamic>) onRejectUser;
  final Function(Map<String, dynamic>) onApproveBalanceRequest;
  final Function(Map<String, dynamic>) onRejectBalanceRequest;
  final Function(int) onToggleBanClient;
  final Function(Map<String, dynamic>) onShowTaxDialog;
  final Function(double) onTransferFeeChanged;
  final Function(double) onWithdrawalFeeChanged;
  final Function(double) onPaymentFeeChanged;
  final VoidCallback onSaveFees;
  final int pendingUsersCount;
  final VoidCallback onTestApi;
  final bool showApiTestDialog;
  final String? apiTestResult;
  final VoidCallback onCloseApiTestDialog;

  const AdminTabBarView({
    super.key,
    required this.tabController,
    required this.isDarkMode,
    required this.pendingUsers,
    required this.balanceRequests,
    required this.activeClients,
    required this.transferFee,
    required this.withdrawalFee,
    required this.paymentFee,
    required this.onApproveUser,
    required this.onRejectUser,
    required this.onApproveBalanceRequest,
    required this.onRejectBalanceRequest,
    required this.onToggleBanClient,
    required this.onShowTaxDialog,
    required this.onTransferFeeChanged,
    required this.onWithdrawalFeeChanged,
    required this.onPaymentFeeChanged,
    required this.onSaveFees,
    required this.pendingUsersCount,
    required this.onTestApi,
    required this.showApiTestDialog,
    this.apiTestResult,
    required this.onCloseApiTestDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabBarView(
          controller: tabController,
          children: [
            OngletApprobationsAdmin(
              isDarkMode: isDarkMode,
              pendingUsers: pendingUsers,
              balanceRequests: balanceRequests,
              onApproveUser: onApproveUser,
              onRejectUser: onRejectUser,
              onApproveBalanceRequest: onApproveBalanceRequest,
              onRejectBalanceRequest: onRejectBalanceRequest,
            ),
            OngletClientsAdmin(
              isDarkMode: isDarkMode,
              activeClients: activeClients,
              onToggleBanClient: onToggleBanClient,
              onShowTaxDialog: onShowTaxDialog,
            ),
            OngletFraisAdmin(
              isDarkMode: isDarkMode,
              transferFee: transferFee,
              withdrawalFee: withdrawalFee,
              paymentFee: paymentFee,
              onTransferFeeChanged: onTransferFeeChanged,
              onWithdrawalFeeChanged: onWithdrawalFeeChanged,
              onPaymentFeeChanged: onPaymentFeeChanged,
              onSaveFees: onSaveFees,
            ),
            OngletStatsAdmin(
              isDarkMode: isDarkMode,
              pendingUsersCount: pendingUsersCount,
              onTestApi: onTestApi,
            ),
          ],
        ),
        ApiTestDialog(
          isVisible: showApiTestDialog,
          result: apiTestResult,
          onClose: onCloseApiTestDialog,
        ),
      ],
    );
  }
}
