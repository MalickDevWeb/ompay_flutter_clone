import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user preferences and app settings
class PreferencesService {
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _scannerEnabledKey = 'scanner_enabled';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _lastLoginKey = 'last_login';
  static const String _appVersionKey = 'app_version';

  /// Theme preferences
  static Future<void> setThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDarkMode);
  }

  static Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? true; // Default to dark mode
  }

  /// Language preferences
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'fr'; // Default to French
  }

  /// Scanner preferences
  static Future<void> setScannerEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_scannerEnabledKey, enabled);
  }

  static Future<bool> getScannerEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_scannerEnabledKey) ?? true; // Default to enabled
  }

  /// Biometric authentication preferences
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  static Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false; // Default to disabled
  }

  /// Notification preferences
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true; // Default to enabled
  }

  /// Login tracking
  static Future<void> setLastLogin(DateTime loginTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLoginKey, loginTime.toIso8601String());
  }

  static Future<DateTime?> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final loginString = prefs.getString(_lastLoginKey);
    return loginString != null ? DateTime.tryParse(loginString) : null;
  }

  /// App version tracking
  static Future<void> setAppVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appVersionKey, version);
  }

  static Future<String?> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_appVersionKey);
  }

  /// Custom preference storage
  static Future<void> setCustomPreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final customKey = 'custom_$key';

    if (value is String) {
      await prefs.setString(customKey, value);
    } else if (value is int) {
      await prefs.setInt(customKey, value);
    } else if (value is double) {
      await prefs.setDouble(customKey, value);
    } else if (value is bool) {
      await prefs.setBool(customKey, value);
    } else {
      // For complex objects, store as JSON string
      await prefs.setString(customKey, value.toString());
    }
  }

  static Future<dynamic> getCustomPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final customKey = 'custom_$key';

    // Try different types in order of likelihood
    if (prefs.containsKey(customKey)) {
      // Check if it's a string first
      final stringValue = prefs.getString(customKey);
      if (stringValue != null) return stringValue;

      // Check if it's an int
      final intValue = prefs.getInt(customKey);
      if (intValue != null) return intValue;

      // Check if it's a double
      final doubleValue = prefs.getDouble(customKey);
      if (doubleValue != null) return doubleValue;

      // Check if it's a bool
      final boolValue = prefs.getBool(customKey);
      if (boolValue != null) return boolValue;
    }

    return null;
  }

  /// Clear all preferences
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Clear user-specific preferences (keep app settings)
  static Future<void> clearUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Keep app-wide settings, remove user-specific ones
    final themeMode = prefs.getBool(_themeModeKey);
    final language = prefs.getString(_languageKey);
    final scannerEnabled = prefs.getBool(_scannerEnabledKey);
    final biometricEnabled = prefs.getBool(_biometricEnabledKey);
    final notificationsEnabled = prefs.getBool(_notificationsEnabledKey);
    final appVersion = prefs.getString(_appVersionKey);

    await prefs.clear();

    // Restore app-wide settings
    if (themeMode != null) await prefs.setBool(_themeModeKey, themeMode);
    if (language != null) await prefs.setString(_languageKey, language);
    if (scannerEnabled != null) await prefs.setBool(_scannerEnabledKey, scannerEnabled);
    if (biometricEnabled != null) await prefs.setBool(_biometricEnabledKey, biometricEnabled);
    if (notificationsEnabled != null) await prefs.setBool(_notificationsEnabledKey, notificationsEnabled);
    if (appVersion != null) await prefs.setString(_appVersionKey, appVersion);
  }

  /// Get all preferences for debugging
  static Future<Map<String, dynamic>> getAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final allPrefs = <String, dynamic>{};

    for (final key in prefs.getKeys()) {
      allPrefs[key] = prefs.get(key);
    }

    return allPrefs;
  }

  /// Initialize default preferences on first app launch
  static Future<void> initializeDefaults() async {
    final prefs = await SharedPreferences.getInstance();

    // Set defaults only if not already set
    if (!prefs.containsKey(_themeModeKey)) {
      await setThemeMode(true); // Dark mode by default
    }

    if (!prefs.containsKey(_languageKey)) {
      await setLanguage('fr'); // French by default
    }

    if (!prefs.containsKey(_scannerEnabledKey)) {
      await setScannerEnabled(true); // Scanner enabled by default
    }

    if (!prefs.containsKey(_biometricEnabledKey)) {
      await setBiometricEnabled(false); // Biometric disabled by default
    }

    if (!prefs.containsKey(_notificationsEnabledKey)) {
      await setNotificationsEnabled(true); // Notifications enabled by default
    }
  }
}
