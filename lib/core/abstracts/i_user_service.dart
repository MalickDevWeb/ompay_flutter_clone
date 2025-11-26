import '../models/api_result.dart';
import '../../models/responses/balance_response.dart';
import '../../models/entities/compte_model.dart';
import '../../models/requests/create_account_request.dart';
import '../../models/responses/create_account_response.dart';
import '../../models/responses/delete_account_response.dart';
import '../../models/responses/restore_account_response.dart';
import '../../models/responses/switch_account_response.dart';
import '../../models/entities/transaction_model.dart';
import '../../models/responses/transaction_response.dart';
import '../../models/requests/update_account_request.dart';
import '../../models/entities/user_model.dart';
import '../../models/requests/otp_confirmation_request.dart';
import '../../models/requests/withdrawal_request.dart';
import '../../models/requests/unified_transaction_request.dart';
import '../../models/requests/admin_virtual_purchase_request.dart';
import '../../models/requests/balance_request.dart';
import '../../models/requests/balance_purchase_request.dart';
import '../../models/responses/balance_purchase_response.dart';
import '../../models/requests/client_deposit_request.dart';
import '../../models/requests/deposit_request.dart';
import '../../models/requests/withdrawal_confirmation_request.dart';
import '../../models/requests/confirm_withdrawal_request.dart';
import '../../models/requests/virtual_purchase_request.dart';
import '../../models/requests/register_request.dart';
import '../../models/responses/register_response.dart';
import '../../models/requests/login_request.dart';
import '../../models/responses/login_response.dart';
import '../../models/responses/logout_response.dart';

abstract class IUserService {
  Future<ApiResult<SendOtpResponse>> sendOtp(String phone);
  Future<ApiResult<LoginOtpResponse>> loginOtp(String phone, String otp);
  Future<ApiResult<StatusModel>> getStatus();

  // User registration and profile management
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request);
  Future<ApiResult<UserModel>> getProfile();
  Future<ApiResult<StatusModel>> updateProfile(UserModel user);
  Future<ApiResult<LoginResponse>> login(LoginRequest request);
  Future<ApiResult<LogoutResponse>> logout();

  Future<ApiResult<ComptesResponse>> getMyAccounts();
  Future<ApiResult<CreateAccountResponse>> createAccount(CreateAccountRequest request);
  Future<ApiResult<BalanceResponse>> getAccountBalance(String accountNumber);
  Future<ApiResult<UpdateAccountResponse>> updateAccount(String accountNumber, UpdateAccountRequest request);
  Future<ApiResult<SwitchAccountResponse>> switchActiveAccount(String accountNumber);
  Future<ApiResult<DeleteAccountResponse>> deleteAccount(String accountNumber);
  Future<ApiResult<OtpConfirmationResponse>> confirmDeleteAccount(OtpConfirmationRequest request);
  Future<ApiResult<RestoreAccountResponse>> restoreAccount(String accountNumber);
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
  });
  Future<ApiResult<TransactionModel>> getTransaction(String transactionId);
  Future<ApiResult<TransactionModel>> makeWithdrawal(WithdrawalRequest request);
  Future<ApiResult<TransactionModel>> makeUnifiedTransaction(UnifiedTransactionRequest request);
  Future<ApiResult<TransactionModel>> requestBalance(BalanceRequest request);
  Future<ApiResult<BalancePurchaseResponse>> requestBalancePurchase(BalancePurchaseRequest request);
  Future<ApiResult<TransactionModel>> makeDeposit(DepositRequest request);
  Future<ApiResult<TransactionModel>> makeClientDeposit(ClientDepositRequest request);
  Future<ApiResult<TransactionModel>> confirmWithdrawal(ConfirmWithdrawalRequest request);
  Future<ApiResult<TransactionModel>> confirmWithdrawalWithCode(WithdrawalConfirmationRequest request);
  Future<ApiResult<TransactionModel>> makeVirtualPurchase(VirtualPurchaseRequest request);
  Future<ApiResult<TransactionModel>> makeAdminVirtualPurchase(AdminVirtualPurchaseRequest request);
}
