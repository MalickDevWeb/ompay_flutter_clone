/// Application configuration management
library;

import 'env_config.dart';

class AppConfig {
  static String get apiBaseUrl {
    // Try to get from loaded environment variables first
    final envUrl = _getEnvVar('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    // Fallback to compile-time environment variable
    const compileTimeUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8000'
    );

    return compileTimeUrl;
  }

  static String _getEnvVar(String key) {
    try {
      // Import here to avoid circular dependency
      return EnvConfig.get(key);
    } catch (e) {
      return '';
    }
  }

  static const int maxOtpAttempts = 3;
  static const Duration requestTimeout = Duration(seconds: 10);
  static const int maxAccountsPerUser = 4;
  static const double maxTransactionAmount = 1000000.0;

  // UI Configuration
  static const int maxLoginAttempts = 3;
  static const Duration otpValidityDuration = Duration(minutes: 5);

  // Validation rules
  static const int minAccountNameLength = 3;
  static const int maxAccountNameLength = 50;
  static const int otpLength = 6;
}
