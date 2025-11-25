import '../../core/abstracts/api_client.dart';
import '../../models/pending_users_response.dart';
import '../../models/pending_balance_requests_response.dart';
import '../../models/active_clients_response.dart';
import '../../models/pending_user.dart';
import '../../models/pending_balance_request.dart';
import '../../models/active_client.dart';
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
}
