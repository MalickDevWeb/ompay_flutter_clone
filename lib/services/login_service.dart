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
  List<CompteModel>? _clientAccounts;
  double? _clientBalance;
  List<TransactionModel>? _clientTransactions;

  bool _isDataLoading = false;

  LoginService(this.userService, this.authService);

  // Getters for client data
  UserModel? get clientProfile => _clientProfile;
  List<CompteModel>? get clientAccounts => _clientAccounts;
  double? get clientBalance => _clientBalance;
  List<TransactionModel>? get clientTransactions => _clientTransactions;
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

        // Load additional client data if user is a client
        if (result.data!.user?.type?.toLowerCase() == 'client') {
          print('👤 Client user detected, user ID: ${result.data!.user?.id}');
          if (result.data!.user?.id == null) {
            print('⚠️  Warning: User ID is null, proceeding with data loading but errors may occur');
          }
          print('👤 Loading additional client data...');
          await _loadClientData();
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

  /// Load client-specific data after login
  Future<void> _loadClientData() async {
    _isDataLoading = true;
    notifyListeners();
    try {
      print('📊 Loading client profile...');
      final profileResult = await userService.getProfile();
      if (profileResult.isSuccess && profileResult.data != null) {
        print('✅ Profile loaded: ${profileResult.data!.nom} ${profileResult.data!.prenom}');
        // Store profile data for client page
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
          (account) => account.statut.toLowerCase() == 'actif', // Assuming 'actif' means active
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
        // Set default balance since accounts failed
        _clientBalance = 0.0;
        // Try to load transactions anyway, in case they don't depend on accounts
        print('📋 Attempting to load transactions despite accounts failure...');
        final transactionsResult = await userService.getTransactions(perPage: 20);
        if (transactionsResult.isSuccess && transactionsResult.data != null) {
          print('✅ Transactions loaded: ${transactionsResult.data!.data.data.length} transactions');
          _clientTransactions = transactionsResult.data!.data.data;
        } else {
          print('❌ Failed to load transactions: ${transactionsResult.error}');
          _clientTransactions = []; // Ensure it's not null
        }
      }
    } catch (e, stackTrace) {
      print('❌ Error loading client data: $e');
      print('Stack trace: $stackTrace');
    } finally {
      _isDataLoading = false;
      notifyListeners();
    }
  }
}
