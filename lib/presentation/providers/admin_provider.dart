import 'package:flutter/material.dart';
import 'package:test_flutter/core/abstracts/api_client.dart';
import 'package:test_flutter/data/services/admin_service.dart';
import 'package:test_flutter/models/entities/pending_user.dart';
import 'package:test_flutter/models/requests/pending_balance_request.dart';
import 'package:test_flutter/models/entities/active_client.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService;

  AdminProvider(ApiClient apiClient) : _adminService = AdminService(apiClient: apiClient);

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  // Pending Users state
  List<PendingUser>? _pendingUsers;
  List<PendingUser>? get pendingUsers => _pendingUsers;
  bool _isLoadingPendingUsers = false;
  bool get isLoadingPendingUsers => _isLoadingPendingUsers;
  String? _pendingUsersError;
  String? get pendingUsersError => _pendingUsersError;

  // Balance Requests state
  List<PendingBalanceRequest>? _balanceRequests;
  List<PendingBalanceRequest>? get balanceRequests => _balanceRequests;
  bool _isLoadingBalanceRequests = false;
  bool get isLoadingBalanceRequests => _isLoadingBalanceRequests;
  String? _balanceRequestsError;
  String? get balanceRequestsError => _balanceRequestsError;

  // Active Clients state
  List<ActiveClient>? _activeClients;
  List<ActiveClient>? get activeClients => _activeClients;
  bool _isLoadingActiveClients = false;
  bool get isLoadingActiveClients => _isLoadingActiveClients;
  String? _activeClientsError;
  String? get activeClientsError => _activeClientsError;

  // Computed getters for UI (convert models to maps)
  List<Map<String, dynamic>> get pendingUsersMaps => _pendingUsers?.map((user) => user.toJson()).toList() ?? [];
  List<Map<String, dynamic>> get balanceRequestsMaps => _balanceRequests?.map((request) => request.toJson()).toList() ?? [];
  List<Map<String, dynamic>> get activeClientsMaps => _activeClients?.map((client) => client.toJson()).toList() ?? [];

  Future<void> fetchPendingUsers({int limit = 10, int offset = 0}) async {
    _isLoadingPendingUsers = true;
    _pendingUsersError = null;
    notifyListeners();

    try {
      _pendingUsers = await _adminService.getPendingUsers(limit: limit, offset: offset);
    } catch (e) {
      _pendingUsersError = e.toString();
      _pendingUsers = null;
    } finally {
      _isLoadingPendingUsers = false;
      notifyListeners();
    }
  }

  Future<void> fetchBalanceRequests({int limit = 10, int offset = 0}) async {
    _isLoadingBalanceRequests = true;
    _balanceRequestsError = null;
    notifyListeners();

    try {
      _balanceRequests = await _adminService.getBalanceRequests(limit: limit, offset: offset);
    } catch (e) {
      _balanceRequestsError = e.toString();
      _balanceRequests = null;
    } finally {
      _isLoadingBalanceRequests = false;
      notifyListeners();
    }
  }

  Future<void> fetchActiveClients({int limit = 10, int offset = 0}) async {
    _isLoadingActiveClients = true;
    _activeClientsError = null;
    notifyListeners();

    try {
      _activeClients = await _adminService.getActiveClients(limit: limit, offset: offset);
    } catch (e) {
      _activeClientsError = e.toString();
      _activeClients = null;
    } finally {
      _isLoadingActiveClients = false;
      notifyListeners();
    }
  }

  double get transferFee => _adminService.getTransferFee();
  double get withdrawalFee => _adminService.getWithdrawalFee();
  double get paymentFee => _adminService.getPaymentFee();

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTransferFee(double value) {
    _adminService.setTransferFee(value);
    notifyListeners();
  }

  void setWithdrawalFee(double value) {
    _adminService.setWithdrawalFee(value);
    notifyListeners();
  }

  void setPaymentFee(double value) {
    _adminService.setPaymentFee(value);
    notifyListeners();
  }

  void approveUser(Map<String, dynamic> user) {
    _adminService.approveUser(user);
    notifyListeners();
  }

  void rejectUser(Map<String, dynamic> user) {
    _adminService.rejectUser(user);
    notifyListeners();
  }

  void approveBalanceRequest(Map<String, dynamic> request) {
    _adminService.approveBalanceRequest(request);
    notifyListeners();
  }

  void rejectBalanceRequest(Map<String, dynamic> request) {
    _adminService.rejectBalanceRequest(request);
    notifyListeners();
  }

  void toggleBanClient(int index) {
    _adminService.toggleBanClient(index);
    notifyListeners();
  }

  void showTaxDialog(Map<String, dynamic> client) {
    // Implementation for showing tax dialog
  }

  void saveGlobalFees() {
    _adminService.saveGlobalFees();
    notifyListeners();
  }
}
