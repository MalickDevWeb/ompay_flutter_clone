import '../models/api_result.dart';
import '../../models/balance_response.dart';
import '../../models/compte_model.dart';
import '../../models/create_account_request.dart';
import '../../models/delete_account_response.dart';
import '../../models/restore_account_response.dart';
import '../../models/switch_account_response.dart';
import '../../models/transaction_model.dart';
import '../../models/transaction_response.dart';
import '../../models/update_account_request.dart';
import '../../models/user_model.dart';
import '../../models/otp_confirmation_request.dart';
import '../../models/withdrawal_request.dart';
import '../../models/unified_transaction_request.dart';
import '../../models/admin_virtual_purchase_request.dart';
import '../../models/balance_request.dart';
import '../../models/balance_purchase_request.dart';
import '../../models/balance_purchase_response.dart';
import '../../models/client_deposit_request.dart';
import '../../models/deposit_request.dart';
import '../../models/withdrawal_confirmation_request.dart';
import '../../models/confirm_withdrawal_request.dart';
import '../../models/virtual_purchase_request.dart';
import '../../models/register_request.dart';
import '../../models/register_response.dart';

abstract class IUserService {
  Future<ApiResult<SendOtpResponse>> sendOtp(String phone);
  Future<ApiResult<LoginOtpResponse>> loginOtp(String phone, String otp);
  Future<ApiResult<StatusModel>> getStatus();

  // User registration and profile management
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request);
  Future<ApiResult<UserModel>> getProfile();
  Future<ApiResult<StatusModel>> updateProfile(UserModel user);
  Future<ApiResult<StatusModel>> sendLogoutOtp();
  Future<ApiResult<StatusModel>> logout(String otpCode);

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
