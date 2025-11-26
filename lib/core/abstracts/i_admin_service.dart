import '../models/api_result.dart';
import '../../models/entities/transaction_model.dart';
import '../../models/responses/pending_users_response.dart';
import '../../models/responses/pending_balance_requests_response.dart';
import '../../models/responses/admin_actions_response.dart';
import '../../models/requests/update_transfer_rights_request.dart';
import '../../models/responses/update_transfer_rights_response.dart';
import '../../models/responses/daily_statistics_response.dart';
import '../../models/requests/global_fees_request.dart';
import '../../models/responses/global_fees_response.dart';
import '../../models/requests/create_user_account_request.dart';
import '../../models/responses/create_user_account_response.dart';
import '../../models/requests/admin_user_action_request.dart';
import '../../models/responses/admin_user_action_response.dart';
import '../../models/requests/admin_balance_request_action_request.dart';
import '../../models/requests/admin_virtual_purchase_request.dart';
import '../../models/requests/admin_virtual_purchase_transaction_request.dart';
import '../../models/responses/admin_accounts_response.dart';
import '../../models/entities/user_model.dart';
import '../../models/responses/paginated_response.dart';
import '../../models/requests/create_user_request.dart';
import '../../models/requests/update_user_request.dart';
import '../../models/entities/compte_model.dart';
import '../../models/requests/create_account_request.dart';
import '../../models/responses/create_account_response.dart';
import '../../models/requests/update_account_request.dart';

abstract class IAdminService {
  Future<ApiResult<PendingUsersResponse>> getPendingUsers();
  Future<ApiResult<PendingBalanceRequestsResponse>> getPendingBalanceRequests();
  Future<ApiResult<AdminActionsResponse>> getAdminActions({
    String? actionType,
    String? adminId,
    String? targetUserId,
    String? dateFrom,
    String? dateTo,
    int? perPage,
  });
  Future<ApiResult<UpdateTransferRightsResponse>> updateUserTransferRights(
    String userId,
    UpdateTransferRightsRequest request,
  );
  Future<ApiResult<DailyStatisticsResponse>> getDailyStatistics();
  Future<ApiResult<GlobalFeesResponse>> updateGlobalFees(GlobalFeesRequest request);
  Future<ApiResult<CreateUserAccountResponse>> createUserAccount(
    String userId,
    CreateUserAccountRequest request,
  );

  // New admin methods
  Future<ApiResult<AdminUserActionResponse>> takeUserAction(
    String telephone,
    AdminUserActionRequest request,
  );
  Future<ApiResult<AdminUserActionResponse>> setUserTax(
    String userId,
    double taxPercentage,
  );
  Future<ApiResult<PaginatedResponse<CompteModel>>> getAllAccounts({
    int? page,
    int? limit,
    String? sortBy,
    String? order,
    int? utilisateurId,
    String? type,
  });
  Future<ApiResult<AdminUserActionResponse>> takeBalanceRequestAction(
    String telephone,
    AdminBalanceRequestActionRequest request,
  );
  Future<ApiResult<AdminUserActionResponse>> purchaseVirtualMoney(
    AdminVirtualPurchaseRequest request,
  );
  Future<ApiResult<TransactionModel>> purchaseVirtualMoneyTransaction(
    AdminVirtualPurchaseTransactionRequest request,
  );

  // User management endpoints
  Future<ApiResult<PaginatedResponse<UserModel>>> getAllUsers({
    int? page,
    int? limit,
    String? sortBy,
    String? order,
    String? type,
  });
  Future<ApiResult<UserModel>> getUser(int userId);
  Future<ApiResult<Map<String, dynamic>>> createUser(CreateUserRequest request);
  Future<ApiResult<Map<String, dynamic>>> updateUser(int userId, UpdateUserRequest request);
  Future<ApiResult<Map<String, dynamic>>> deleteUser(int userId);

  // Account management endpoints
  Future<ApiResult<CompteModel>> getAccount(int accountId);
  Future<ApiResult<CreateAccountResponse>> createAccount(CreateAccountRequest request);
  Future<ApiResult<Map<String, dynamic>>> updateAccount(int accountId, UpdateAccountRequest request);
  Future<ApiResult<Map<String, dynamic>>> deleteAccount(int accountId);
  Future<ApiResult<PaginatedResponse<Map<String, dynamic>>>> getAccountTransactions(
    int accountId, {
    int? page,
    int? limit,
    String? sortBy,
    String? order,
    String? type,
    String? statut,
  });
}
