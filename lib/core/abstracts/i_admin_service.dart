import '../models/api_result.dart';
import '../../models/transaction_model.dart';
import '../../models/pending_users_response.dart';
import '../../models/pending_balance_requests_response.dart';
import '../../models/admin_actions_response.dart';
import '../../models/update_transfer_rights_request.dart';
import '../../models/update_transfer_rights_response.dart';
import '../../models/daily_statistics_response.dart';
import '../../models/global_fees_request.dart';
import '../../models/global_fees_response.dart';
import '../../models/create_user_account_request.dart';
import '../../models/create_user_account_response.dart';
import '../../models/admin_user_action_request.dart';
import '../../models/admin_user_action_response.dart';
import '../../models/admin_balance_request_action_request.dart';
import '../../models/admin_virtual_purchase_request.dart';
import '../../models/admin_virtual_purchase_transaction_request.dart';
import '../../models/admin_accounts_response.dart';

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
  Future<ApiResult<AdminAccountsResponse>> getAllAccounts({
    String? statut,
    String? numeroCompte,
    String? titulaire,
    String? search,
    String? sortBy,
    String? sortDirection,
    int? perPage,
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
}
