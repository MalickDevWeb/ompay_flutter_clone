import '../core/abstracts/api_client.dart';
import '../core/abstracts/i_admin_service.dart';
import '../core/models/api_result.dart';
import '../models/responses/pending_users_response.dart';
import '../models/responses/pending_balance_requests_response.dart';
import '../models/responses/admin_actions_response.dart';
import '../models/requests/update_transfer_rights_request.dart';
import '../models/responses/update_transfer_rights_response.dart';
import '../models/responses/daily_statistics_response.dart';
import '../models/requests/global_fees_request.dart';
import '../models/responses/global_fees_response.dart';
import '../models/requests/create_user_account_request.dart';
import '../models/responses/create_user_account_response.dart';
import '../models/requests/admin_user_action_request.dart';
import '../models/responses/admin_user_action_response.dart';
import '../models/requests/admin_balance_request_action_request.dart';
import '../models/requests/admin_virtual_purchase_request.dart';
import '../models/requests/admin_virtual_purchase_transaction_request.dart';
import '../models/entities/transaction_model.dart';
import '../models/responses/admin_accounts_response.dart';
import '../models/entities/compte_model.dart';
import '../models/entities/user_model.dart';
import '../models/responses/paginated_response.dart';
import '../models/requests/create_user_request.dart';
import '../models/requests/update_user_request.dart';
import '../models/requests/create_account_request.dart';
import '../models/responses/create_account_response.dart';
import '../models/requests/update_account_request.dart';

class AdminService implements IAdminService {
  final ApiClient api;

  AdminService(this.api);

  @override
  Future<ApiResult<PendingUsersResponse>> getPendingUsers() async {
    print('📋 AdminService calling getPendingUsers');
    final result = await api.get('/admin/users/pending');
    print('📋 AdminService getPendingUsers result: ${result.isSuccess}');

    if (result.isSuccess && result.data != null) {
      try {
        final response = PendingUsersResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to retrieve pending users");
  }

  @override
  Future<ApiResult<PendingBalanceRequestsResponse>> getPendingBalanceRequests() async {
    final result = await api.get('/admin/balance-requests/pending');

    if (result.isSuccess && result.data != null) {
      try {
        final response = PendingBalanceRequestsResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from balance requests API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to retrieve pending balance requests");
  }

  @override
  Future<ApiResult<AdminActionsResponse>> getAdminActions({
    String? actionType,
    String? adminId,
    String? targetUserId,
    String? dateFrom,
    String? dateTo,
    int? perPage,
  }) async {
    final queryParams = <String, String>{};

    if (actionType != null) queryParams['action_type'] = actionType;
    if (adminId != null) queryParams['admin_id'] = adminId;
    if (targetUserId != null) queryParams['target_user_id'] = targetUserId;
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (perPage != null) queryParams['per_page'] = perPage.toString();

    // Build query string
    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final result = await api.get('/admin/actions$queryString');

    if (result.isSuccess && result.data != null) {
      try {
        final response = AdminActionsResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from admin actions API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to retrieve admin actions");
  }

  @override
  Future<ApiResult<UpdateTransferRightsResponse>> updateUserTransferRights(
    String userId,
    UpdateTransferRightsRequest request,
  ) async {
    final result = await api.put('/admin/users/$userId/rights', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = UpdateTransferRightsResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from transfer rights API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to update transfer rights");
  }

  @override
  Future<ApiResult<DailyStatisticsResponse>> getDailyStatistics() async {
    final result = await api.get('/api/admin/statistics/daily');

    if (result.isSuccess && result.data != null) {
      try {
        final response = DailyStatisticsResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from daily statistics API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to retrieve daily statistics");
  }

  @override
  Future<ApiResult<GlobalFeesResponse>> updateGlobalFees(GlobalFeesRequest request) async {
    final result = await api.put('/api/admin/fees/global', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = GlobalFeesResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from global fees API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to update global fees");
  }

  @override
  Future<ApiResult<CreateUserAccountResponse>> createUserAccount(
    String userId,
    CreateUserAccountRequest request,
  ) async {
    // Input validation
    if (userId.trim().isEmpty) {
      return ApiResult.failure("User ID cannot be empty");
    }
    if (request.nomCompte.trim().isEmpty) {
      return ApiResult.failure("Account name cannot be empty");
    }

    final result = await api.post('/admin/users/$userId/comptes', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = CreateUserAccountResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from create account API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to create user account");
  }

  @override
  Future<ApiResult<AdminUserActionResponse>> takeUserAction(
    String telephone,
    AdminUserActionRequest request,
  ) async {
    final result = await api.post('/admin/users/$telephone/action', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = AdminUserActionResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from user action API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to take user action");
  }

  @override
  Future<ApiResult<AdminUserActionResponse>> setUserTax(
    String userId,
    double taxPercentage,
  ) async {
    final result = await api.put('/api/admin/users/$userId/tax', {
      'tax_percentage': taxPercentage,
    });

    if (result.isSuccess && result.data != null) {
      try {
        final response = AdminUserActionResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from set user tax API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to set user tax");
  }

  @override
  Future<ApiResult<PaginatedResponse<CompteModel>>> getAllAccounts({
    int? page,
    int? limit,
    String? sortBy,
    String? order,
    int? utilisateurId,
    String? type,
  }) async {
    final queryParams = <String, String>{};

    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (order != null) queryParams['order'] = order;
    if (utilisateurId != null) queryParams['utilisateur_id'] = utilisateurId.toString();
    if (type != null) queryParams['type'] = type;

    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final result = await api.get('/api/comptes$queryString');

    if (result.isSuccess && result.data != null) {
      try {
        final response = PaginatedResponse.fromJson(
          result.data!,
          (json) => CompteModel.fromJson(json),
        );
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get all accounts API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get all accounts");
  }

  @override
  Future<ApiResult<AdminUserActionResponse>> takeBalanceRequestAction(
    String telephone,
    AdminBalanceRequestActionRequest request,
  ) async {
    final result = await api.post('/admin/balance-requests/$telephone/action', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = AdminUserActionResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from balance request action API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to take balance request action");
  }

  @override
  Future<ApiResult<AdminUserActionResponse>> purchaseVirtualMoney(
    AdminVirtualPurchaseRequest request,
  ) async {
    final result = await api.post('/admin/purchase-virtual-money', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = AdminUserActionResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from virtual purchase API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to purchase virtual money");
  }

  @override
  Future<ApiResult<TransactionModel>> purchaseVirtualMoneyTransaction(
    AdminVirtualPurchaseTransactionRequest request,
  ) async {
    final result = await api.post('/transactions/achat-virtuel', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final transaction = TransactionModel.fromJson(result.data!);
        return ApiResult.success(transaction);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from virtual purchase transaction API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to purchase virtual money transaction");
  }

  @override
  Future<ApiResult<PaginatedResponse<UserModel>>> getAllUsers({
    int? page,
    int? limit,
    String? sortBy,
    String? order,
    String? type,
  }) async {
    final queryParams = <String, String>{};

    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (order != null) queryParams['order'] = order;
    if (type != null) queryParams['type'] = type;

    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final result = await api.get('/api/utilisateurs$queryString');

    if (result.isSuccess && result.data != null) {
      try {
        final response = PaginatedResponse.fromJson(
          result.data!,
          (json) => UserModel.fromJson(json),
        );
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get all users API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get all users");
  }

  @override
  Future<ApiResult<UserModel>> getUser(int userId) async {
    final result = await api.get('/api/utilisateurs/$userId');

    if (result.isSuccess && result.data != null) {
      try {
        final user = UserModel.fromJson(result.data!['data']);
        return ApiResult.success(user);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get user API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get user");
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> createUser(CreateUserRequest request) async {
    final result = await api.post('/api/utilisateurs', request.toJson());

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to create user");
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateUser(int userId, UpdateUserRequest request) async {
    final result = await api.put('/api/utilisateurs/$userId', request.toJson());

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to update user");
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteUser(int userId) async {
    final result = await api.delete('/api/utilisateurs/$userId');

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to delete user");
  }

  @override
  Future<ApiResult<CompteModel>> getAccount(int accountId) async {
    final result = await api.get('/api/comptes/$accountId');

    if (result.isSuccess && result.data != null) {
      try {
        final account = CompteModel.fromJson(result.data!['data']);
        return ApiResult.success(account);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get account API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get account");
  }

  @override
  Future<ApiResult<CreateAccountResponse>> createAccount(CreateAccountRequest request) async {
    final result = await api.post('/api/comptes', request.toJson());

    if (result.isSuccess && result.data != null) {
      try {
        final response = CreateAccountResponse.fromJson(result.data!);
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from create account API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to create account");
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateAccount(int accountId, UpdateAccountRequest request) async {
    final result = await api.put('/api/comptes/$accountId', request.toJson());

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to update account");
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteAccount(int accountId) async {
    final result = await api.delete('/api/comptes/$accountId');

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to delete account");
  }

  @override
  Future<ApiResult<PaginatedResponse<Map<String, dynamic>>>> getAccountTransactions(
    int accountId, {
    int? page,
    int? limit,
    String? sortBy,
    String? order,
    String? type,
    String? statut,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (order != null) queryParams['order'] = order;
    if (type != null) queryParams['type'] = type;
    if (statut != null) queryParams['statut'] = statut;

    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final result = await api.get('/api/comptes/$accountId/transactions$queryString');

    if (result.isSuccess && result.data != null) {
      try {
        final response = PaginatedResponse.fromJson(
          result.data!,
          (json) => json as Map<String, dynamic>,
        );
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get account transactions API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get account transactions");
  }

  // Admin stats endpoints
  Future<ApiResult<Map<String, dynamic>>> getTotalBalance() async {
    final result = await api.get('/api/stats/solde-total');

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to get total balance");
  }

  Future<ApiResult<Map<String, dynamic>>> getTransactionStats() async {
    final result = await api.get('/api/stats/transactions');

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to get transaction stats");
  }

  Future<ApiResult<PaginatedResponse<UserModel>>> getMerchants() async {
    final result = await api.get('/api/utilisateurs/commercants');

    if (result.isSuccess && result.data != null) {
      try {
        final response = PaginatedResponse.fromJson(
          result.data!,
          (json) => UserModel.fromJson(json),
        );
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get merchants API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get merchants");
  }

  Future<ApiResult<PaginatedResponse<UserModel>>> getSuppliers() async {
    final result = await api.get('/api/utilisateurs/fournisseurs');

    if (result.isSuccess && result.data != null) {
      try {
        final response = PaginatedResponse.fromJson(
          result.data!,
          (json) => UserModel.fromJson(json),
        );
        return ApiResult.success(response);
      } catch (e) {
        return ApiResult.failure("Invalid JSON response from get suppliers API: $e");
      }
    }

    return ApiResult.failure(result.error ?? "Failed to get suppliers");
  }

  Future<ApiResult<Map<String, dynamic>>> getUserStats(int userId) async {
    final result = await api.get('/api/stats/utilisateur/$userId');

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to get user stats");
  }
}
