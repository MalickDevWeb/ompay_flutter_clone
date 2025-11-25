import '../core/abstracts/api_client.dart';
import '../core/abstracts/i_admin_service.dart';
import '../core/models/api_result.dart';
import '../models/pending_users_response.dart';
import '../models/pending_balance_requests_response.dart';
import '../models/admin_actions_response.dart';
import '../models/update_transfer_rights_request.dart';
import '../models/update_transfer_rights_response.dart';
import '../models/daily_statistics_response.dart';
import '../models/global_fees_request.dart';
import '../models/global_fees_response.dart';
import '../models/create_user_account_request.dart';
import '../models/create_user_account_response.dart';
import '../models/admin_user_action_request.dart';
import '../models/admin_user_action_response.dart';
import '../models/admin_balance_request_action_request.dart';
import '../models/admin_virtual_purchase_request.dart';
import '../models/admin_virtual_purchase_transaction_request.dart';
import '../models/transaction_model.dart';
import '../models/admin_accounts_response.dart';

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
  Future<ApiResult<AdminAccountsResponse>> getAllAccounts({
    String? statut,
    String? numeroCompte,
    String? titulaire,
    String? search,
    String? sortBy,
    String? sortDirection,
    int? perPage,
  }) async {
    final queryParams = <String, String>{};

    if (statut != null) queryParams['statut'] = statut;
    if (numeroCompte != null) queryParams['numero_compte'] = numeroCompte;
    if (titulaire != null) queryParams['titulaire'] = titulaire;
    if (search != null) queryParams['search'] = search;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (sortDirection != null) queryParams['sort_direction'] = sortDirection;
    if (perPage != null) queryParams['per_page'] = perPage.toString();

    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final result = await api.get('/admin/comptes$queryString');

    if (result.isSuccess && result.data != null) {
      try {
        final response = AdminAccountsResponse.fromJson(result.data!);
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
}
