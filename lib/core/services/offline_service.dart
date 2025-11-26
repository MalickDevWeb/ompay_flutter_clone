import 'package:test_flutter/core/services/cache_service.dart';
import 'package:test_flutter/core/services/logging_service.dart';
import 'package:test_flutter/core/services/preferences_service.dart';
import 'package:flutter/material.dart';

/// Service for managing offline mode and connectivity
class OfflineService {
  static final OfflineService _instance = OfflineService._internal();
  factory OfflineService() => _instance;

  OfflineService._internal();

  bool _isOfflineMode = false;
  bool _isOnline = true; // Assume online by default

  /// Get current online status
  bool get isOnline => _isOnline;

  /// Get current offline mode status
  bool get isOfflineMode => _isOfflineMode;

  /// Initialize offline service
  Future<void> initialize() async {
    // Load offline mode preference
    _isOfflineMode = await PreferencesService.getCustomPreference('offline_mode') ?? false;

    LoggingService.info('OfflineService initialized - Online: $_isOnline, OfflineMode: $_isOfflineMode');
  }

  /// Enable offline mode
  Future<void> enableOfflineMode() async {
    if (_isOfflineMode) return;

    _isOfflineMode = true;
    await PreferencesService.setCustomPreference('offline_mode', true);

    LoggingService.info('Offline mode enabled');
  }

  /// Disable offline mode
  Future<void> disableOfflineMode() async {
    if (!_isOfflineMode) return;

    _isOfflineMode = false;
    await PreferencesService.setCustomPreference('offline_mode', false);

    LoggingService.info('Offline mode disabled');
  }

  /// Toggle offline mode
  Future<void> toggleOfflineMode() async {
    if (_isOfflineMode) {
      await disableOfflineMode();
    } else {
      await enableOfflineMode();
    }
  }

  /// Check if offline mode should be used
  bool shouldUseOfflineMode() {
    return _isOfflineMode || !_isOnline;
  }

  /// Get cached data if offline mode is active
  Future<T?> getOfflineData<T>(String key, {Duration? maxAge}) async {
    if (!shouldUseOfflineMode()) return null;

    try {
      final cachedData = await CacheService.getCachedData(key);
      if (cachedData == null) return null;

      LoggingService.debug('Retrieved offline data for key: $key');
      return cachedData as T?;
    } catch (error) {
      LoggingService.error('Failed to get offline data for key: $key', error: error);
      return null;
    }
  }

  /// Show offline mode dialog
  static Future<void> showOfflineModeDialog(BuildContext context) async {
    final offlineService = OfflineService();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mode Hors Ligne'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              offlineService.isOnline
                  ? 'Vous êtes connecté. Voulez-vous activer le mode hors ligne ?'
                  : 'Vous êtes hors ligne. Le mode hors ligne est automatiquement activé.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  offlineService.isOnline ? Icons.wifi : Icons.wifi_off,
                  color: offlineService.isOnline ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  offlineService.isOnline ? 'Connecté' : 'Hors ligne',
                  style: TextStyle(
                    color: offlineService.isOnline ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (offlineService.isOnline) ...[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await offlineService.enableOfflineMode();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mode hors ligne activé'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Activer'),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ],
      ),
    );
  }

  /// Get offline status widget
  static Widget buildOfflineStatusWidget({bool compact = false}) {
    final offlineService = OfflineService();

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            offlineService.isOnline ? Icons.wifi : Icons.wifi_off,
            size: 16,
            color: offlineService.isOnline ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            offlineService.isOnline ? 'En ligne' : 'Hors ligne',
            style: TextStyle(
              fontSize: 12,
              color: offlineService.isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: offlineService.isOnline ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: offlineService.isOnline ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            offlineService.isOnline ? Icons.wifi : Icons.wifi_off,
            size: 16,
            color: offlineService.isOnline ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            offlineService.isOnline ? 'En ligne' : 'Hors ligne',
            style: TextStyle(
              fontSize: 12,
              color: offlineService.isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (offlineService.isOfflineMode) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'OFFLINE',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

}
