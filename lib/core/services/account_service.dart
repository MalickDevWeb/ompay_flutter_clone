import 'package:test_flutter/core/services/cache_service.dart';
import 'package:test_flutter/core/services/error_handler.dart';
import 'package:test_flutter/core/services/logging_service.dart';
import 'package:test_flutter/models/entities/compte_model.dart';
import 'package:test_flutter/di/dependency_injection.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

/// Service for managing multiple user accounts and switching between them
class AccountService {
  static CompteModel? _activeAccount;
  static List<CompteModel> _userAccounts = [];
  static bool _isLoadingAccounts = false;

  /// Get the currently active account
  static CompteModel? get activeAccount => _activeAccount;

  /// Get all user accounts
  static List<CompteModel> get userAccounts => _userAccounts;

  /// Check if user has multiple accounts
  static bool get hasMultipleAccounts => _userAccounts.length > 1;

  /// Check if accounts are currently loading
  static bool get isLoadingAccounts => _isLoadingAccounts;

  /// Load user accounts from cache or API
  static Future<void> loadUserAccounts(BuildContext context) async {
    if (_isLoadingAccounts) return;

    _isLoadingAccounts = true;

    try {
      // Try to load from cache first
      final cachedAccounts = await CacheService.getCachedUserAccounts();
      if (cachedAccounts != null && cachedAccounts is List) {
        _userAccounts = List<CompteModel>.from(
          cachedAccounts.map((account) => CompteModel.fromJson(account))
        );

        // Set first account as active if none selected
        if (_activeAccount == null && _userAccounts.isNotEmpty) {
          _activeAccount = _userAccounts.first;
        }

        LoggingService.info('Loaded ${_userAccounts.length} accounts from cache');
      }

      // Load from API in background
      await _loadAccountsFromAPI(context);

    } catch (error, stackTrace) {
      LoggingService.error('Failed to load accounts', error: error, stackTrace: stackTrace);
      ErrorHandler.showErrorSnackBar(context, error, stackTrace: stackTrace);
    } finally {
      _isLoadingAccounts = false;
    }
  }

  /// Load accounts from API
  static Future<void> _loadAccountsFromAPI(BuildContext context) async {
    final userService = Provider.of<AppContainer>(context, listen: false).userService;

    final result = await ErrorHandler.handleAsync(
      () => userService.getMyAccounts(),
      operationName: 'Load user accounts',
      context: context,
    );

    if (result != null && result.isSuccess && result.data != null) {
      _userAccounts = result.data!.data.comptes;

      // Cache the accounts
      await CacheService.cacheUserAccounts(
        _userAccounts.map((account) => account.toJson()).toList()
      );

      // Set first account as active if none selected
      if (_activeAccount == null && _userAccounts.isNotEmpty) {
        _activeAccount = _userAccounts.first;
      }

      LoggingService.info('Loaded ${_userAccounts.length} accounts from API');
    }
  }

  /// Switch to a different account
  static Future<bool> switchToAccount(BuildContext context, CompteModel account) async {
    if (!_userAccounts.contains(account)) {
      LoggingService.warning('Attempted to switch to invalid account: ${account.numeroCompte}');
      return false;
    }

    try {
      _activeAccount = account;

      // Clear transaction cache for old account
      await CacheService.clearAllCache();

      // Reload data for new account
      await _loadTransactionsForAccount(context, account);

      LoggingService.info('Switched to account: ${account.numeroCompte}');

      // Notify UI of account change
      // This would typically trigger a rebuild of dependent widgets
      return true;

    } catch (error, stackTrace) {
      LoggingService.error('Failed to switch account', error: error, stackTrace: stackTrace);
      ErrorHandler.showErrorSnackBar(context, error, stackTrace: stackTrace);
      return false;
    }
  }

  /// Load transactions for specific account
  static Future<void> _loadTransactionsForAccount(BuildContext context, CompteModel account) async {
    final userService = Provider.of<AppContainer>(context, listen: false).userService;

    final result = await ErrorHandler.handleAsync(
      () => userService.getTransactions(perPage: 10),
      operationName: 'Load transactions for account ${account.numeroCompte}',
      context: context,
    );

    if (result != null && result.isSuccess && result.data != null) {
      final transactions = result.data!.data.data;

      // Cache transactions for current account
      await CacheService.cacheUserTransactions(
        transactions.map((t) => t.toJson()).toList()
      );

      LoggingService.debug('Loaded ${transactions.length} transactions for account ${account.numeroCompte}');
    }
  }

  /// Get account display name
  static String getAccountDisplayName(CompteModel account) {
    if (account.nomCompte != null && account.nomCompte!.isNotEmpty) {
      return account.nomCompte!;
    }
    return 'Compte ${account.numeroCompte}';
  }

  /// Get account balance formatted
  static String getAccountBalanceFormatted(CompteModel account) {
    return '${account.solde.toStringAsFixed(0)} FCFA';
  }

  /// Check if account is active
  static bool isAccountActive(CompteModel account) {
    return _activeAccount?.numeroCompte == account.numeroCompte;
  }

  /// Get account by ID
  static CompteModel? getAccountById(String accountId) {
    try {
      return _userAccounts.firstWhere((account) => account.numeroCompte == accountId);
    } catch (e) {
      return null;
    }
  }

  /// Refresh accounts data
  static Future<void> refreshAccounts(BuildContext context) async {
    await CacheService.clearAllCache();
    await loadUserAccounts(context);
  }

  /// Clear all account data (on logout)
  static void clearAccountData() {
    _activeAccount = null;
    _userAccounts.clear();
    _isLoadingAccounts = false;
  }

  /// Show account switcher dialog
  static Future<void> showAccountSwitcher(BuildContext context) async {
    if (!hasMultipleAccounts) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous n\'avez qu\'un seul compte'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final selectedAccount = await showDialog<CompteModel>(
      context: context,
      builder: (context) => AccountSwitcherDialog(
        accounts: _userAccounts,
        activeAccount: _activeAccount,
      ),
    );

    if (selectedAccount != null && selectedAccount != _activeAccount) {
      final success = await switchToAccount(context, selectedAccount);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Compté changé: ${getAccountDisplayName(selectedAccount)}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// Dialog for switching between accounts
class AccountSwitcherDialog extends StatelessWidget {
  final List<CompteModel> accounts;
  final CompteModel? activeAccount;

  const AccountSwitcherDialog({
    super.key,
    required this.accounts,
    this.activeAccount,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Changer de compte'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            final isActive = AccountService.isAccountActive(account);

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isActive ? Colors.orange : Colors.grey,
                child: Icon(
                  isActive ? Icons.check : Icons.account_balance,
                  color: Colors.white,
                ),
              ),
              title: Text(AccountService.getAccountDisplayName(account)),
              subtitle: Text(AccountService.getAccountBalanceFormatted(account)),
              trailing: isActive ? const Icon(Icons.check_circle, color: Colors.orange) : null,
              onTap: () => Navigator.of(context).pop(account),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
