import '../core/abstracts/api_client.dart';
import '../core/abstracts/i_user_service.dart';
import '../core/models/api_result.dart';
import '../models/responses/balance_response.dart';
import '../models/entities/compte_model.dart';
import '../models/requests/create_account_request.dart';
import '../models/responses/delete_account_response.dart';
import '../models/responses/restore_account_response.dart';
import '../models/responses/switch_account_response.dart';
import '../models/entities/transaction_model.dart';
import '../models/responses/transaction_response.dart';
import '../models/requests/update_account_request.dart';
import '../models/entities/user_model.dart';
import '../models/requests/otp_confirmation_request.dart';
import '../models/requests/withdrawal_request.dart';
import '../models/requests/unified_transaction_request.dart';
import '../models/requests/admin_virtual_purchase_request.dart';
import '../models/requests/balance_request.dart';
import '../models/requests/balance_purchase_request.dart';
import '../models/responses/balance_purchase_response.dart';
import '../models/requests/client_deposit_request.dart';
import '../models/requests/deposit_request.dart';
import '../models/requests/withdrawal_confirmation_request.dart';
import '../models/requests/confirm_withdrawal_request.dart';
import '../models/requests/virtual_purchase_request.dart';
import '../models/requests/register_request.dart';
import '../models/responses/register_response.dart';
import '../models/requests/login_request.dart';
import '../models/responses/login_response.dart';
import '../models/responses/logout_response.dart';
import '../models/responses/create_account_response.dart';
import '../models/responses/user_details_response.dart';

class UserService implements IUserService {
  final ApiClient api;

  UserService(this.api);

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    final result = await api.post('/api/auth/login', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = LoginResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from login API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to login");
  }

  @override
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request) async {
    final result = await api.post('/api/register', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = RegisterResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from register API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to register user");
  }

  @override
  Future<ApiResult<UserModel>> getProfile() async {
    final result = await api.get('/api/user');

    if (result.isSuccess && result.data != null) {
      try {
        final user = UserModel.fromJson(result.data!['data']);
        return ApiResult.success(user);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get profile API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get user profile");
  }

  @override
  Future<ApiResult<UserDetailsResponse>> getUserDetails() async {
    final result = await api.get('/api/user/details');

    if (result.isSuccess && result.data != null) {
      try {
        final response = UserDetailsResponse.fromJson(result.data!['data']);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get user details API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get user details");
  }

  @override
  Future<ApiResult<StatusModel>> updateProfile(UserModel user) async {
    final result = await api.put('/user', user.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final status = StatusModel.fromJson(result.data!);
        return ApiResult.success(status);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from update profile API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to update user profile");
  }


  @override
  Future<ApiResult<LogoutResponse>> logout() async {
    final result = await api.post('/api/auth/logout', {});

    if (result.isSuccess && result.data != null) {
      try {
        final response = LogoutResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from logout API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to logout");
  }

 @override
  Future<ApiResult<SendOtpResponse>> sendOtp(String telephone) async {
    final result = await api.post('/api/sendOTP', {"telephone": telephone});

   if (result.isSuccess && result.data != null) {
     try {
       final response = SendOtpResponse.fromJson(result.data!);
       return ApiResult.success(response);
     } catch (e) {
       return ApiResult.failure("Invalid JSON response: $e");
     }
   }

   return ApiResult.failure(result.error ?? "Unknown error");
 }


  @override
  Future<ApiResult<StatusModel>> getStatus() async {
    final result = await api.get('/api/status');

    if (result.isSuccess && result.data != null) {
      try {
        final status = StatusModel.fromJson(result.data!);
        return ApiResult.success(status);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<LoginOtpResponse>> loginOtp(String telephone, String otpCode) async {
    final result = await api.post('/api/login/otp', {"telephone": telephone, "otp_code": otpCode});

    if (result.isSuccess && result.data != null) {
      try {
        final response = LoginOtpResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }


  @override
  Future<ApiResult<ComptesResponse>> getMyAccounts() async {
    print('🔍 Calling getMyAccounts API...');
    final result = await api.get('/api/comptes');
    print('🔍 API result: ${result.isSuccess}, error: ${result.error}');

    if (result.isSuccess && result.data != null) {
      try {
        final response = ComptesResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<CreateAccountResponse>> createAccount(CreateAccountRequest request) async {
    final result = await api.post('/api/comptes', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = CreateAccountResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<BalanceResponse>> getAccountBalance(String accountNumber) async {
    final result = await api.get('/api/compte/$accountNumber/solde');

    if (result.isSuccess && result.data != null) {
      try {
        final response = BalanceResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<BalanceResponse>> getActiveAccountBalance() async {
    final result = await api.get('/api/compte/solde');

    if (result.isSuccess && result.data != null) {
      try {
        final response = BalanceResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<UpdateAccountResponse>> updateAccount(String accountNumber, UpdateAccountRequest request) async {
    final result = await api.put('/api/compte/$accountNumber/modifier', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = UpdateAccountResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<SwitchAccountResponse>> switchActiveAccount(String accountNumber) async {
    final result = await api.post('/api/compte/$accountNumber/switch', {});

    if (result.isSuccess && result.data != null) {
      try {
        final response = SwitchAccountResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<DeleteAccountResponse>> deleteAccount(String accountNumber) async {
    final result = await api.delete('/api/compte/$accountNumber/supprimer');

    if (result.isSuccess && result.data != null) {
      try {
        final response = DeleteAccountResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<OtpConfirmationResponse>> confirmDeleteAccount(OtpConfirmationRequest request) async {
    final result = await api.post('/otp/confirmation', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = OtpConfirmationResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<RestoreAccountResponse>> restoreAccount(String accountNumber) async {
    final result = await api.post('/api/compte/$accountNumber/restaurer', {});

    if (result.isSuccess && result.data != null) {
      try {
        final response = RestoreAccountResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionResponse>> getTransactions({
    String? type,
    String? statut,
    double? montantMin,
    double? montantMax,
    String? dateDebut,
    String? dateFin,
    String? reference,
    String? search,
    String? sortBy,
    String? sortDirection,
    int? perPage,
  }) async {
    final queryParams = <String, String>{};

    if (type != null) queryParams['type'] = type;
    if (statut != null) queryParams['statut'] = statut;
    if (montantMin != null) queryParams['montant_min'] = montantMin.toString();
    if (montantMax != null) queryParams['montant_max'] = montantMax.toString();
    if (dateDebut != null) queryParams['date_debut'] = dateDebut;
    if (dateFin != null) queryParams['date_fin'] = dateFin;
    if (reference != null) queryParams['reference'] = reference;
    if (search != null) queryParams['search'] = search;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (sortDirection != null) queryParams['sort_direction'] = sortDirection;
    if (perPage != null) queryParams['per_page'] = perPage.toString();

    // Build query string
    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final result = await api.get('/api/transactions$queryString');

    if (result.isSuccess && result.data != null) {
      try {
        final response = TransactionResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> getTransaction(String transactionId) async {
    final result = await api.get('/api/transactions/$transactionId');

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> makeWithdrawal(WithdrawalRequest request) async {
    final result = await api.post('/api/transactions/paiement', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> makeUnifiedTransaction(UnifiedTransactionRequest request) async {
    final result = await api.post('/api/transactions/transfert', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> requestBalance(BalanceRequest request) async {
    final result = await api.post('/api/transactions/demande', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<BalancePurchaseResponse>> requestBalancePurchase(BalancePurchaseRequest request) async {
    final result = await api.post('/api/transactions/demande', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = BalancePurchaseResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> makeDeposit(DepositRequest request) async {
    final result = await api.post('/api/transactions/depot', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> makeClientDeposit(ClientDepositRequest request) async {
    final result = await api.post('/api/transactions/depot', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> confirmWithdrawal(ConfirmWithdrawalRequest request) async {
    final result = await api.post('/api/transactions/confirm-retrait', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> confirmWithdrawalWithCode(WithdrawalConfirmationRequest request) async {
    final result = await api.post('/api/transactions/confirm-retrait', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> makeVirtualPurchase(VirtualPurchaseRequest request) async {
    final result = await api.post('/api/transactions/achat-virtuel', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }

  @override
  Future<ApiResult<TransactionModel>> makeAdminVirtualPurchase(AdminVirtualPurchaseRequest request) async {
    final result = await api.post('/api/transactions/achat-virtuel', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Unknown error");
  }
}
