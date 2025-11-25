import '../core/abstracts/api_client.dart';
import '../core/abstracts/i_user_service.dart';
import '../core/models/api_result.dart';
import '../models/balance_response.dart';
import '../models/compte_model.dart';
import '../models/create_account_request.dart';
import '../models/delete_account_response.dart';
import '../models/restore_account_response.dart';
import '../models/switch_account_response.dart';
import '../models/transaction_model.dart';
import '../models/transaction_response.dart';
import '../models/update_account_request.dart';
import '../models/user_model.dart';
import '../models/otp_confirmation_request.dart';
import '../models/withdrawal_request.dart';
import '../models/unified_transaction_request.dart';
import '../models/admin_virtual_purchase_request.dart';
import '../models/balance_request.dart';
import '../models/balance_purchase_request.dart';
import '../models/balance_purchase_response.dart';
import '../models/client_deposit_request.dart';
import '../models/deposit_request.dart';
import '../models/withdrawal_confirmation_request.dart';
import '../models/confirm_withdrawal_request.dart';
import '../models/virtual_purchase_request.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';

class UserService implements IUserService {
  final ApiClient api;

  UserService(this.api);

  Future<ApiResult<Map<String, dynamic>>> login(String email, String password) {
    return api.post('/auth/login', {"email": email, "password": password});
  }

  @override
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request) async {
    final result = await api.post('/register', request.toJson());

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
    final result = await api.get('/user');

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
  Future<ApiResult<StatusModel>> sendLogoutOtp() async {
    final result = await api.get('/logout/otp');

    if (result.isSuccess && result.data != null) {
      try {
        final status = StatusModel.fromJson(result.data!);
        return ApiResult.success(status);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from send logout OTP API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to send logout OTP");
  }

  @override
  Future<ApiResult<StatusModel>> logout(String otpCode) async {
    final result = await api.post('/logout', {"otp_code": otpCode});

    if (result.isSuccess && result.data != null) {
      try {
        final status = StatusModel.fromJson(result.data!);
        return ApiResult.success(status);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from logout API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to logout");
  }

 @override
 Future<ApiResult<SendOtpResponse>> sendOtp(String telephone) async {
   final result = await api.post('/sendOTP', {"telephone": telephone});

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
    final result = await api.get('/status');

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
    final result = await api.post('/login/otp', {"telephone": telephone, "otp_code": otpCode});

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
    final result = await api.get('/comptes/mesComptes');

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
    final result = await api.post('/compte/nouveaucompte', request.toJson());

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
    final result = await api.get('/compte/$accountNumber/solde');

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
    final result = await api.put('/compte/$accountNumber/modifier', request.toJson());

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
    final result = await api.post('/compte/$accountNumber/switch', {});

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
    final result = await api.delete('/compte/$accountNumber/supprimer');

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
    final result = await api.post('/compte/$accountNumber/restaurer', {});

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

    final result = await api.get('/transactions$queryString');

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
    final result = await api.get('/transactions/$transactionId');

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
    final result = await api.post('/transactions/retrait', request.toJson());

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
    final result = await api.post('/transactions/unified', request.toJson());

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
    final result = await api.post('/transactions/demande', request.toJson());

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
    final result = await api.post('/transactions/demande', request.toJson());

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
    final result = await api.post('/transactions/depot', request.toJson());

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
    final result = await api.post('/transactions/depot', request.toJson());

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
    final result = await api.post('/transactions/confirm-retrait', request.toJson());

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
    final result = await api.post('/transactions/confirm-retrait', request.toJson());

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
    final result = await api.post('/transactions/achat-virtuel', request.toJson());

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
    final result = await api.post('/transactions/achat-virtuel', request.toJson());

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
