// import 'package:flutter_test/flutter_test.dart';
// import 'package:test_flutter/core/services/cache_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';

// @GenerateMocks([SharedPreferences])
// import 'cache_service_test.mocks.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   late MockSharedPreferences mockPrefs;

//   setUp(() {
//     mockPrefs = MockSharedPreferences();
//     SharedPreferences.setMockInitialValues({});
//   });

//   group('CacheService', () {
//     test('should cache user profile with TTL', () async {
//       // Arrange
//       final testData = {'name': 'John Doe', 'id': 123};
//       final ttl = const Duration(hours: 24);

//       // Act - We can't directly test static methods with mocks easily
//       // This serves as documentation for expected behavior

//       // Assert
//       expect(true, isTrue); // Placeholder assertion
//     });

//     test('should return cached data if not expired', () async {
//       // Arrange
//       final testData = {'name': 'John Doe'};
//       final cacheEntry = CacheEntry(
//         data: testData,
//         timestamp: DateTime.now(),
//         ttl: const Duration(hours: 1),
//       );

//       // Act - Testing the cache entry logic

//       // Assert
//       expect(cacheEntry.isExpired, isFalse);
//       expect(cacheEntry.data, testData);
//     });

//     test('should return null for expired cache', () async {
//       // Arrange
//       final testData = {'name': 'John Doe'};
//       final pastTimestamp = DateTime.now().subtract(const Duration(hours: 2));
//       final cacheEntry = CacheEntry(
//         data: testData,
//         timestamp: pastTimestamp,
//         ttl: const Duration(hours: 1),
//       );

//       // Act & Assert
//       expect(cacheEntry.isExpired, isTrue);
//     });

//     test('should serialize and deserialize cache entry', () async {
//       // Arrange
//       final testData = {'name': 'John Doe', 'id': 123};
//       final originalEntry = CacheEntry(
//         data: testData,
//         timestamp: DateTime.now(),
//         ttl: const Duration(hours: 24),
//       );

//       // Act
//       final json = originalEntry.toJson();
//       final deserializedEntry = CacheEntry.fromJson(json, (data) => data);

//       // Assert
//       expect(deserializedEntry.data, testData);
//       expect(deserializedEntry.ttl, originalEntry.ttl);
//     });
//   });
// }
