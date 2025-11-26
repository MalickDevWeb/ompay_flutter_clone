import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logging_service.dart';

/// Secure storage service for sensitive data like tokens
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';

  /// Store authentication tokens securely
  static Future<void> storeAuthTokens({
    required String accessToken,
    String? refreshToken,
    required String tokenType,
    required String userId,
    required String userType,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      if (refreshToken != null) _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(key: _tokenTypeKey, value: tokenType),
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _userTypeKey, value: userType),
    ]);
  }

  /// Retrieve access token
  static Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: _accessTokenKey);
      LoggingService.debug('Retrieved access token successfully');
      return token;
    } catch (e, stackTrace) {
      LoggingService.error('Failed to retrieve access token', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Retrieve token type
  static Future<String?> getTokenType() async {
    return await _storage.read(key: _tokenTypeKey);
  }

  /// Retrieve user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Retrieve user type
  static Future<String?> getUserType() async {
    return await _storage.read(key: _userTypeKey);
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    return accessToken != null && userId != null;
  }

  /// Clear all stored authentication data
  static Future<void> clearAuthData() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _tokenTypeKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _userTypeKey),
    ]);
  }

  /// Store user preferences
  static Future<void> storeUserPreference(String key, String value) async {
    await _storage.write(key: 'pref_$key', value: value);
  }

  /// Retrieve user preference
  static Future<String?> getUserPreference(String key) async {
    return await _storage.read(key: 'pref_$key');
  }

  /// Clear all user preferences
  static Future<void> clearUserPreferences() async {
    final allKeys = await _storage.readAll();
    final preferenceKeys = allKeys.keys.where((key) => key.startsWith('pref_'));

    await Future.wait(
      preferenceKeys.map((key) => _storage.delete(key: key)),
    );
  }

  /// Clear all stored data (complete logout)
  static Future<void> clearAllData() async {
    await _storage.deleteAll();
  }

  /// Get authorization header for API calls
  static Future<String?> getAuthorizationHeader() async {
    final tokenType = await getTokenType();
    final accessToken = await getAccessToken();

    if (tokenType != null && accessToken != null) {
      return '$tokenType $accessToken';
    }
    return null;
  }
}
