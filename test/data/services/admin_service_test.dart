import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_flutter/core/abstracts/api_client.dart';
import 'package:test_flutter/core/models/api_result.dart';
import 'package:test_flutter/data/services/admin_service.dart';
import 'package:test_flutter/data/mock/admin_mock_data.dart';
import 'package:test_flutter/models/entities/pending_user.dart';
import 'package:test_flutter/models/requests/pending_balance_request.dart';
import 'package:test_flutter/models/entities/active_client.dart';
import 'package:test_flutter/models/entities/user_model.dart';

@GenerateMocks([ApiClient])
import 'admin_service_test.mocks.dart';

// Mock data for responses
final mockPendingUsers = [
  PendingUser(
    nom: 'Mamadou',
    prenom: 'Sow',
    telephone: '771234567',
    email: 'mamadou@example.com',
    type: 'Client',
    statut: 'Pending',
    pin: '1234',
  ),
  PendingUser(
    nom: 'Fatou',
    prenom: 'Diop',
    telephone: '776543210',
    email: 'fatou@example.com',
    type: 'Fournisseur',
    statut: 'Pending',
    pin: '5678',
  ),
];

final mockBalanceRequests = [
  PendingBalanceRequest(
    id: '1',
    supplier: UserModel(
      nom: 'Sarr',
      prenom: 'Boutique',
      telephone: '775551234',
    ),
    montant: 500000.0,
    statut: 'Pending',
  ),
  PendingBalanceRequest(
    id: '2',
    supplier: UserModel(
      nom: 'Modou',
      prenom: 'Chez',
      telephone: '779998888',
    ),
    montant: 250000.0,
    statut: 'Pending',
  ),
];

final mockActiveClients = [
  ActiveClient(
    nom: 'Abdoulaye Diallo',
    telephone: '782917770',
    solde: '50000',
    statut: 'Actif',
    isBanned: false,
  ),
  ActiveClient(
    nom: 'Djeuli ODC',
    telephone: '786284027',
    solde: '120000',
    statut: 'Actif',
    isBanned: false,
  ),
];

void main() {
  late AdminService adminService;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    adminService = AdminService(apiClient: mockApiClient);

    // Setup mock responses
    when(mockApiClient.get(any)).thenAnswer((invocation) {
      final url = invocation.positionalArguments[0] as String;
      final limitMatch = RegExp(r'limit=(\d+)').firstMatch(url);
      final offsetMatch = RegExp(r'offset=(\d+)').firstMatch(url);
      final limit = limitMatch != null ? int.parse(limitMatch.group(1)!) : 10;
      final offset = offsetMatch != null ? int.parse(offsetMatch.group(1)!) : 0;

      if (url.contains('pending-users')) {
        final end = (offset + limit).clamp(0, mockPendingUsers.length);
        final data = offset < mockPendingUsers.length ? mockPendingUsers.sublist(offset, end) : [];
        return Future.value(ApiResult.success({'status': 'success', 'data': data.map((e) => e.toJson()).toList()}));
      } else if (url.contains('balance-requests')) {
        final end = (offset + limit).clamp(0, mockBalanceRequests.length);
        final data = offset < mockBalanceRequests.length ? mockBalanceRequests.sublist(offset, end) : [];
        return Future.value(ApiResult.success({'status': 'success', 'data': data.map((e) => e.toJson()).toList()}));
      } else if (url.contains('active-clients')) {
        final end = (offset + limit).clamp(0, mockActiveClients.length);
        final data = offset < mockActiveClients.length ? mockActiveClients.sublist(offset, end) : [];
        return Future.value(ApiResult.success({'status': 'success', 'data': data.map((e) => e.toJson()).toList()}));
      }
      return Future.value(ApiResult.failure('Unknown URL'));
    });
  });

  group('AdminService Batch Fetching', () {
    group('getPendingUsers', () {
      test('returns List<PendingUser>', () async {
        final result = await adminService.getPendingUsers();
        expect(result, isA<List<PendingUser>>());
      });

      test('default parameters return all pending users', () async {
        final result = await adminService.getPendingUsers();
        expect(result.length, 2);
        expect(result[0].nom, 'Mamadou');
        expect(result[1].nom, 'Fatou');
      });

      test('limit=1, offset=0 returns first user', () async {
        final result = await adminService.getPendingUsers(limit: 1, offset: 0);
        expect(result.length, 1);
        expect(result[0].nom, 'Mamadou');
      });

      test('limit=1, offset=1 returns second user', () async {
        final result = await adminService.getPendingUsers(limit: 1, offset: 1);
        expect(result.length, 1);
        expect(result[0].nom, 'Fatou');
      });

      test('limit=2, offset=0 returns all users', () async {
        final result = await adminService.getPendingUsers(limit: 2, offset: 0);
        expect(result.length, 2);
        expect(result[0].nom, 'Mamadou');
        expect(result[1].nom, 'Fatou');
      });

      test('offset beyond data length returns empty list', () async {
        final result = await adminService.getPendingUsers(limit: 10, offset: 3);
        expect(result, isEmpty);
      });

      test('limit=0 returns empty list', () async {
        final result = await adminService.getPendingUsers(limit: 0, offset: 0);
        expect(result, isEmpty);
      });
    });

    group('getBalanceRequests', () {
      test('returns List<PendingBalanceRequest>', () async {
        final result = await adminService.getBalanceRequests();
        expect(result, isA<List<PendingBalanceRequest>>());
      });

      test('default parameters return all balance requests', () async {
        final result = await adminService.getBalanceRequests();
        expect(result.length, 2);
        expect(result[0].supplier.nom, 'Sarr');
        expect(result[1].supplier.nom, 'Modou');
      });

      test('limit=1, offset=0 returns first request', () async {
        final result = await adminService.getBalanceRequests(limit: 1, offset: 0);
        expect(result.length, 1);
        expect(result[0].supplier.nom, 'Sarr');
      });

      test('limit=1, offset=1 returns second request', () async {
        final result = await adminService.getBalanceRequests(limit: 1, offset: 1);
        expect(result.length, 1);
        expect(result[0].supplier.nom, 'Modou');
      });

      test('limit=2, offset=0 returns all requests', () async {
        final result = await adminService.getBalanceRequests(limit: 2, offset: 0);
        expect(result.length, 2);
        expect(result[0].supplier.nom, 'Sarr');
        expect(result[1].supplier.nom, 'Modou');
      });

      test('offset beyond data length returns empty list', () async {
        final result = await adminService.getBalanceRequests(limit: 10, offset: 3);
        expect(result, isEmpty);
      });

      test('limit=0 returns empty list', () async {
        final result = await adminService.getBalanceRequests(limit: 0, offset: 0);
        expect(result, isEmpty);
      });
    });

    group('getActiveClients', () {
      test('returns List<ActiveClient>', () async {
        final result = await adminService.getActiveClients();
        expect(result, isA<List<ActiveClient>>());
      });

      test('default parameters return all active clients', () async {
        final result = await adminService.getActiveClients();
        expect(result.length, 2);
        expect(result[0].nom, 'Abdoulaye Diallo');
        expect(result[1].nom, 'Djeuli ODC');
      });

      test('limit=1, offset=0 returns first client', () async {
        final result = await adminService.getActiveClients(limit: 1, offset: 0);
        expect(result.length, 1);
        expect(result[0].nom, 'Abdoulaye Diallo');
      });

      test('limit=1, offset=1 returns second client', () async {
        final result = await adminService.getActiveClients(limit: 1, offset: 1);
        expect(result.length, 1);
        expect(result[0].nom, 'Djeuli ODC');
      });

      test('limit=2, offset=0 returns all clients', () async {
        final result = await adminService.getActiveClients(limit: 2, offset: 0);
        expect(result.length, 2);
        expect(result[0].nom, 'Abdoulaye Diallo');
        expect(result[1].nom, 'Djeuli ODC');
      });

      test('offset beyond data length returns empty list', () async {
        final result = await adminService.getActiveClients(limit: 10, offset: 3);
        expect(result, isEmpty);
      });

      test('limit=0 returns empty list', () async {
        final result = await adminService.getActiveClients(limit: 0, offset: 0);
        expect(result, isEmpty);
      });
    });
  });
}
