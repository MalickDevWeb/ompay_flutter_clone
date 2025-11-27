import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_flutter/core/abstracts/api_client.dart';
import 'package:test_flutter/core/models/api_result.dart';
import 'package:test_flutter/services/user_service.dart';
import 'package:test_flutter/models/responses/balance_response.dart';

@GenerateMocks([ApiClient])
import 'user_service_test.mocks.dart';

void main() {
  late UserService userService;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    userService = UserService(mockApiClient);
  });

  group('UserService - Balance Tests', () {
    group('getActiveAccountBalance', () {
      test('returns successful balance response', () async {
        // Mock successful API response
        final mockResponse = {
          'status': 'success',
          'message': 'Balance retrieved successfully',
          'data': {
            'solde': 150000.0,
            'numero_compte': '123456789',
            'nom_compte': 'Compte Principal'
          }
        };

        when(mockApiClient.get('/compte/solde'))
            .thenAnswer((_) => Future.value(ApiResult.success(mockResponse)));

        final result = await userService.getActiveAccountBalance();

        expect(result.isSuccess, true);
        expect(result.data!.status, 'success');
        expect(result.data!.data.solde, 150000.0);
        expect(result.data!.data.numeroCompte, '123456789');
        expect(result.data!.data.nomCompte, 'Compte Principal');
      });

      test('returns failure on API error', () async {
        when(mockApiClient.get('/compte/solde'))
            .thenAnswer((_) => Future.value(ApiResult.failure('Network error')));

        final result = await userService.getActiveAccountBalance();

        expect(result.isSuccess, false);
        expect(result.error, 'Network error');
      });

      test('handles invalid JSON response gracefully', () async {
        final invalidResponse = {'invalid': 'data'};

        when(mockApiClient.get('/compte/solde'))
            .thenAnswer((_) => Future.value(ApiResult.success(invalidResponse)));

        final result = await userService.getActiveAccountBalance();

        // BalanceResponse.fromJson handles missing fields gracefully with defaults
        expect(result.isSuccess, true);
        expect(result.data!.status, ''); // default empty string
        expect(result.data!.data.solde, 0.0); // default value
      });
    });

    group('getAccountBalance', () {
      test('returns balance for specific account', () async {
        const accountNumber = '987654321';
        final mockResponse = {
          'status': 'success',
          'message': 'Balance retrieved successfully',
          'data': {
            'solde': 75000.0,
            'numero_compte': accountNumber,
            'nom_compte': 'Compte Épargne'
          }
        };

        when(mockApiClient.get('/compte/$accountNumber/solde'))
            .thenAnswer((_) => Future.value(ApiResult.success(mockResponse)));

        final result = await userService.getAccountBalance(accountNumber);

        expect(result.isSuccess, true);
        expect(result.data!.data.solde, 75000.0);
        expect(result.data!.data.numeroCompte, accountNumber);
      });
    });
  });
}
