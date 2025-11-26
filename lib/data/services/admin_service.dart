import '../../core/abstracts/api_client.dart';
import '../../models/responses/pending_users_response.dart';
import '../../models/responses/pending_balance_requests_response.dart';
import '../../models/responses/active_clients_response.dart';
import '../../models/entities/pending_user.dart';
import '../../models/requests/pending_balance_request.dart';
import '../../models/entities/active_client.dart';
import '../../models/entities/user_model.dart';
import '../../models/responses/paginated_response.dart';
import '../../models/requests/create_user_request.dart';
import '../../models/requests/update_user_request.dart';
import '../../models/entities/compte_model.dart';
import '../../models/requests/create_account_request.dart';
import '../../models/responses/create_account_response.dart';
import '../../models/requests/update_account_request.dart';
import '../../models/responses/transaction_response.dart';
import '../../core/models/api_result.dart';
import '../mock/admin_mock_data.dart';

class AdminService {
  final ApiClient apiClient;

  AdminService({required this.apiClient});

  Future<List<PendingUser>> getPendingUsers({int limit = 10, int offset = 0}) async {
    final result = await apiClient.get('/admin/pending-users?limit=$limit&offset=$offset');
    if (result.isSuccess) {
      final response = PendingUsersResponse.fromJson(result.data!);
      return response.data;
    } else {
      throw Exception(result.error ?? 'Failed to fetch pending users');
    }
  }

  Future<List<PendingBalanceRequest>> getBalanceRequests({int limit = 10, int offset = 0}) async {
    final result = await apiClient.get('/admin/balance-requests?limit=$limit&offset=$offset');
    if (result.isSuccess) {
      final response = PendingBalanceRequestsResponse.fromJson(result.data!);
      return response.data;
    } else {
      throw Exception(result.error ?? 'Failed to fetch balance requests');
    }
  }

  Future<List<ActiveClient>> getActiveClients({int limit = 10, int offset = 0}) async {
    final result = await apiClient.get('/admin/active-clients?limit=$limit&offset=$offset');
    if (result.isSuccess) {
      final response = ActiveClientsResponse.fromJson(result.data!);
      return response.data;
    } else {
      throw Exception(result.error ?? 'Failed to fetch active clients');
    }
  }

  double getTransferFee() => AdminMockData.transferFee;
  double getWithdrawalFee() => AdminMockData.withdrawalFee;
  double getPaymentFee() => AdminMockData.paymentFee;

  void setTransferFee(double value) => AdminMockData.transferFee = value;
  void setWithdrawalFee(double value) => AdminMockData.withdrawalFee = value;
  void setPaymentFee(double value) => AdminMockData.paymentFee = value;

  void approveUser(Map<String, dynamic> user) {
    // Logic to approve user
  }

  void rejectUser(Map<String, dynamic> user) {
    // Logic to reject user
  }

  void approveBalanceRequest(Map<String, dynamic> request) {
    // Logic to approve balance request
  }

  void rejectBalanceRequest(Map<String, dynamic> request) {
    // Logic to reject balance request
  }

  void toggleBanClient(int index) {
    AdminMockData.activeClients[index]['isBanned'] =
        !AdminMockData.activeClients[index]['isBanned'];
  }

  void saveGlobalFees() {
    // Logic to save fees
  }

  // User management endpoints
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

    final result = await apiClient.get('/api/utilisateurs$queryString');

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

  Future<ApiResult<UserModel>> getUser(int userId) async {
    final result = await apiClient.get('/api/utilisateurs/$userId');

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

  Future<ApiResult<Map<String, dynamic>>> createUser(CreateUserRequest request) async {
    final result = await apiClient.post('/api/utilisateurs', request.toJson());

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to create user");
  }

  Future<ApiResult<Map<String, dynamic>>> updateUser(int userId, UpdateUserRequest request) async {
    final result = await apiClient.put('/api/utilisateurs/$userId', request.toJson());

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to update user");
  }

  Future<ApiResult<Map<String, dynamic>>> deleteUser(int userId) async {
    final result = await apiClient.delete('/api/utilisateurs/$userId');

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to delete user");
  }

  // Account management endpoints
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

    final result = await apiClient.get('/api/comptes$queryString');

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

  Future<ApiResult<CompteModel>> getAccount(int accountId) async {
    final result = await apiClient.get('/api/comptes/$accountId');

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

  Future<ApiResult<CreateAccountResponse>> createAccount(CreateAccountRequest request) async {
    final result = await apiClient.post('/api/comptes', request.toJson());

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

  Future<ApiResult<Map<String, dynamic>>> updateAccount(int accountId, UpdateAccountRequest request) async {
    final result = await apiClient.put('/api/comptes/$accountId', request.toJson());

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to update account");
  }

  Future<ApiResult<Map<String, dynamic>>> deleteAccount(int accountId) async {
    final result = await apiClient.delete('/api/comptes/$accountId');

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    }

    return ApiResult.failure(result.error ?? "Failed to delete account");
  }

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

    final result = await apiClient.get('/api/comptes/$accountId/transactions$queryString');

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
}
