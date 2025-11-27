import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/abstracts/i_user_service.dart';
import '../models/entities/login_result.dart';
import '../models/entities/user_model.dart';
import '../models/entities/compte_model.dart';
import '../models/entities/transaction_model.dart';
import 'auth_service.dart';

class LoginService extends ChangeNotifier {
  final IUserService userService;
  final AuthService authService;

  // Client data storage
  UserModel? _clientProfile;
  List<CompteModel> _clientAccounts = [];
  double _clientBalance = 0.0;
  List<TransactionModel> _clientTransactions = [];

  bool _isDataLoading = false;

  // Real-time sync
  Timer? _syncTimer;
  bool _isRealTimeSyncEnabled = false;
  static const Duration _syncInterval = Duration(seconds: 20); // Check every 10 seconds
  int _lastTransactionCount = 0;
  double _lastBalance = 0.0;

  LoginService(this.userService, this.authService);

  // Getters for client data
  UserModel? get clientProfile => _clientProfile;
  List<CompteModel> get clientAccounts => _clientAccounts;
  double get clientBalance => _clientBalance;
  List<TransactionModel> get clientTransactions => _clientTransactions;
  bool get isDataLoading => _isDataLoading;

  /// Envoi OTP
  Future<LoginResult> sendOtp(String phone) async {
    final result = await userService.sendOtp(phone);
    return LoginResult(
      isSuccess: result.isSuccess,
      message: result.data?.message,
      error: result.error,
    );
  }

  /// Vérifie OTP et effectue login
  Future<LoginResult> loginWithOtp(String phone, String otpCode) async {
    try {
      final result = await userService.loginOtp(phone, otpCode);

      if (result.isSuccess && result.data != null) {
        // Log user information for debugging
        print('🔐 Login successful. User: ${result.data!.user}');
        print('👤 User type: ${result.data!.user?.type}');
        print('📋 Full API response: ${result.data!.toJson()}');

        await authService.login(result.data!);

        // Store basic user info from login response
        _clientProfile = result.data!.user;

        // Load additional client data if user is a client or type is null (defaults to client)
        if (result.data!.user?.type == null || result.data!.user?.type?.toLowerCase() == 'client') {
          print('👤 Client user detected (type: ${result.data!.user?.type}), user ID: ${result.data!.user?.id}');
          if (result.data!.user?.id == null) {
            print('⚠️  Warning: User ID is null, proceeding with data loading but errors may occur');
          }
          print('👤 Loading additional client data...');
          try {
            await _loadClientData();

            // Démarrer la synchronisation en temps réel après le chargement initial
            startRealTimeSync();
            print('🔄 Real-time sync enabled for client');
          } catch (e, stackTrace) {
            print('❌ Unexpected error during client data loading: $e');
            print('Stack trace: $stackTrace');
            // Ensure data is in a safe state
            _clientAccounts = [];
            _clientBalance = 0.0;
            _clientTransactions = [];
            _isDataLoading = false;
            notifyListeners();
          }
        }

        return LoginResult(isSuccess: true, user: result.data!.user);
      } else {
        print('❌ Login failed: ${result.error}');
        return LoginResult(isSuccess: false, error: result.error);
      }
    } catch (e) {
      print('❌ Login error: $e');
      return LoginResult(isSuccess: false, error: e.toString());
    }
  }

  /// Refresh client data after transactions
  Future<void> refreshClientData() async {
    await _loadClientData();

    // Mettre à jour les références pour la synchronisation
    _lastTransactionCount = _clientTransactions.length;
    _lastBalance = _clientBalance;
  }

  /// Load client-specific data after login
  Future<void> _loadClientData() async {
    _isDataLoading = true;
    notifyListeners();
    try {
      print('📊 Loading user details...');
      final detailsResult = await userService.getUserDetails();
      print('📊 Details API Result: isSuccess=${detailsResult.isSuccess}, error=${detailsResult.error}');
      if (detailsResult.isSuccess && detailsResult.data != null) {
        final details = detailsResult.data!;
        print('✅ User details loaded: ${details.nom} ${details.prenom}');

        // Store profile data
        _clientProfile = UserModel(
          id: null, // We don't have this from the details endpoint
          nom: details.nom,
          prenom: details.prenom,
          telephone: details.numero,
          email: null, // Not included in details
          type: null, // Not included in details
        );

        // Store accounts
        _clientAccounts = details.comptes;
        print('✅ Accounts loaded: ${details.comptes.length} accounts');

        // Store balance of active account
        _clientBalance = details.soldeCompteActif ?? 0.0;
        print('✅ Balance loaded: $_clientBalance');

        // Store transactions of active account
        _clientTransactions = details.transactionsCompteActif;
        print('✅ Transactions loaded: ${details.transactionsCompteActif.length} transactions');
      } else {
        print('❌ Failed to load user details: ${detailsResult.error}');
        print('🔄 Falling back to separate API calls...');
        // Fallback to old method if new endpoint fails
        await _loadClientDataFallback();
      }
    } catch (e, stackTrace) {
      print('❌ Error loading client data: $e');
      print('Stack trace: $stackTrace');
      // Fallback to old method
      await _loadClientDataFallback();
    } finally {
      _isDataLoading = false;
      notifyListeners();
    }
  }

  /// Fallback method to load client data using separate API calls
  Future<void> _loadClientDataFallback() async {
    try {
      print('🔄 Falling back to separate API calls...');

      print('📊 Loading client profile...');
      final profileResult = await userService.getProfile();
      if (profileResult.isSuccess && profileResult.data != null) {
        print('✅ Profile loaded: ${profileResult.data!.nom} ${profileResult.data!.prenom}');
        _clientProfile = profileResult.data;
      } else {
        print('❌ Failed to load profile: ${profileResult.error}');
      }

      print('🏦 Loading client accounts...');
      final accountsResult = await userService.getMyAccounts();
      if (accountsResult.isSuccess && accountsResult.data != null && accountsResult.data!.data.comptes.isNotEmpty) {
        print('✅ Accounts loaded: ${accountsResult.data!.data.comptes.length} accounts');
        _clientAccounts = accountsResult.data!.data.comptes;

        // Load balance for the first/active account
        final activeAccount = accountsResult.data!.data.comptes.firstWhere(
          (account) => account.statut.toLowerCase() == 'actif',
          orElse: () => accountsResult.data!.data.comptes.first,
        );

        print('💰 Loading balance for account: ${activeAccount.numeroCompte}');
        final balanceResult = await userService.getAccountBalance(activeAccount.numeroCompte);
        if (balanceResult.isSuccess && balanceResult.data != null) {
          print('✅ Balance loaded: ${balanceResult.data!.data.solde}');
          _clientBalance = balanceResult.data!.data.solde;
        } else {
          print('❌ Failed to load balance: ${balanceResult.error}');
        }

        print('📋 Loading transactions...');
        final transactionsResult = await userService.getTransactions(perPage: 20);
        if (transactionsResult.isSuccess && transactionsResult.data != null) {
          print('✅ Transactions loaded: ${transactionsResult.data!.data.data.length} transactions');
          _clientTransactions = transactionsResult.data!.data.data;
        } else {
          print('❌ Failed to load transactions: ${transactionsResult.error}');
        }
      } else {
        print('❌ Failed to load accounts: ${accountsResult.error}');
        _clientBalance = 0.0;
        print('📋 Attempting to load transactions despite accounts failure...');
        final transactionsResult = await userService.getTransactions(perPage: 20);
        if (transactionsResult.isSuccess && transactionsResult.data != null) {
          print('✅ Transactions loaded: ${transactionsResult.data!.data.data.length} transactions');
          _clientTransactions = transactionsResult.data!.data.data;
        } else {
          print('❌ Failed to load transactions: ${transactionsResult.error}');
          _clientTransactions = [];
        }
      }
    } catch (e, stackTrace) {
      print('❌ Error in fallback loading: $e');
      print('Stack trace: $stackTrace');
      _clientAccounts = [];
      _clientBalance = 0.0;
      _clientTransactions = [];
    }
  }

  /// Démarrer la synchronisation en temps réel
  void startRealTimeSync() {
    if (_isRealTimeSyncEnabled) return;

    _isRealTimeSyncEnabled = true;
    print('🔄 Real-time sync started');

    // Démarrer immédiatement une vérification
    _checkForUpdates();

    // Puis vérifier périodiquement
    _syncTimer = Timer.periodic(_syncInterval, (_) => _checkForUpdates());
  }

  /// Arrêter la synchronisation en temps réel
  void stopRealTimeSync() {
    _isRealTimeSyncEnabled = false;
    _syncTimer?.cancel();
    _syncTimer = null;
    print('⏹️ Real-time sync stopped');
  }

  /// Vérifier les mises à jour en arrière-plan
  Future<void> _checkForUpdates() async {
    if (!_isRealTimeSyncEnabled) return;

    try {
      final detailsResult = await userService.getUserDetails();
      if (detailsResult.isSuccess && detailsResult.data != null) {
        final details = detailsResult.data!;
        final newBalance = details.soldeCompteActif ?? 0.0;
        final newTransactions = details.transactionsCompteActif;

        // Vérifier si des changements ont eu lieu
        bool hasChanges = false;

        if (newBalance != _lastBalance) {
          print('💰 Balance updated: $_lastBalance → $newBalance');
          _lastBalance = newBalance;
          _clientBalance = newBalance;
          hasChanges = true;
        }

        if (newTransactions.length != _lastTransactionCount) {
          print('📋 Transactions updated: $_lastTransactionCount → ${newTransactions.length}');
          _lastTransactionCount = newTransactions.length;
          _clientTransactions = newTransactions;
          hasChanges = true;
        }

        // Mettre à jour les comptes aussi
        if (details.comptes.isNotEmpty && details.comptes != _clientAccounts) {
          _clientAccounts = details.comptes;
          hasChanges = true;
        }

        // Notifier seulement s'il y a des changements
        if (hasChanges) {
          print('🔄 Data updated automatically');
          notifyListeners();
        }
      }
    } catch (e) {
      // Silent error handling for background sync
      print('⚠️ Background sync error: $e');
    }
  }

  /// Forcer une vérification immédiate des mises à jour
  Future<void> forceSyncNow() async {
    await _checkForUpdates();
  }

  @override
  void dispose() {
    stopRealTimeSync();
    super.dispose();
  }
}
