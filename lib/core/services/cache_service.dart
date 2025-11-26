import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache entry with TTL (Time To Live)
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration ttl;

  const CacheEntry({
    required this.data,
    required this.timestamp,
    required this.ttl,
  });

  /// Check if cache entry is expired
  bool get isExpired => DateTime.now().difference(timestamp) > ttl;

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'ttl': ttl.inSeconds,
  };

  /// Create from JSON
  factory CacheEntry.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return CacheEntry<T>(
      data: fromJson(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
      ttl: Duration(seconds: json['ttl']),
    );
  }
}

/// Intelligent caching service with TTL support
class CacheService {
  static const String _userProfileKey = 'user_profile';
  static const String _accountsKey = 'user_accounts';
  static const String _transactionsKey = 'user_transactions';

  static const Duration _defaultProfileTTL = Duration(hours: 24); // 24 hours
  static const Duration _defaultAccountsTTL = Duration(hours: 6); // 6 hours
  static const Duration _defaultTransactionsTTL = Duration(minutes: 30); // 30 minutes

  /// Cache user profile
  static Future<void> cacheUserProfile(dynamic profile) async {
    await _cacheData(_userProfileKey, profile, _defaultProfileTTL);
  }

  /// Get cached user profile
  static Future<dynamic> getCachedUserProfile() async {
    return await _getCachedData(_userProfileKey);
  }

  /// Cache user accounts
  static Future<void> cacheUserAccounts(dynamic accounts) async {
    await _cacheData(_accountsKey, accounts, _defaultAccountsTTL);
  }

  /// Get cached user accounts
  static Future<dynamic> getCachedUserAccounts() async {
    return await _getCachedData(_accountsKey);
  }

  /// Cache user transactions
  static Future<void> cacheUserTransactions(dynamic transactions) async {
    await _cacheData(_transactionsKey, transactions, _defaultTransactionsTTL);
  }

  /// Get cached user transactions
  static Future<dynamic> getCachedUserTransactions() async {
    return await _getCachedData(_transactionsKey);
  }

  /// Generic cache method
  static Future<void> _cacheData(String key, dynamic data, Duration ttl) async {
    final prefs = await SharedPreferences.getInstance();
    final entry = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl,
    );

    final jsonString = jsonEncode(entry.toJson());
    await prefs.setString(key, jsonString);
  }

  /// Generic get cached data method
  static Future<dynamic> _getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString);
      final entry = CacheEntry.fromJson(json, (data) => data);

      if (entry.isExpired) {
        await prefs.remove(key); // Remove expired cache
        return null;
      }

      return entry.data;
    } catch (e) {
      // Invalid cache format, remove it
      await prefs.remove(key);
      return null;
    }
  }

  /// Clear all cached data
  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
    await prefs.remove(_accountsKey);
    await prefs.remove(_transactionsKey);
  }

  /// Clear expired cache entries
  static Future<void> clearExpiredCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = [_userProfileKey, _accountsKey, _transactionsKey];

    for (final key in keys) {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        try {
          final json = jsonDecode(jsonString);
          final entry = CacheEntry.fromJson(json, (data) => data);

          if (entry.isExpired) {
            await prefs.remove(key);
          }
        } catch (e) {
          await prefs.remove(key);
        }
      }
    }
  }

  /// Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    final prefs = await SharedPreferences.getInstance();
    final stats = <String, dynamic>{};

    final keys = [_userProfileKey, _accountsKey, _transactionsKey];

    for (final key in keys) {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        try {
          final json = jsonDecode(jsonString);
          final entry = CacheEntry.fromJson(json, (data) => data);

          stats[key] = {
            'isExpired': entry.isExpired,
            'age': DateTime.now().difference(entry.timestamp).inMinutes,
            'ttl': entry.ttl.inMinutes,
          };
        } catch (e) {
          stats[key] = {'error': 'Invalid cache format'};
        }
      } else {
        stats[key] = {'status': 'not_cached'};
      }
    }

    return stats;
  }

  /// Cache with custom TTL
  static Future<void> cacheWithCustomTTL(String key, dynamic data, Duration ttl) async {
    await _cacheData(key, data, ttl);
  }

  /// Get cached data with custom key
  static Future<dynamic> getCachedData(String key) async {
    return await _getCachedData(key);
  }
}
