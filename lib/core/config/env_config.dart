import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Environment configuration loader
class EnvConfig {
  static final Map<String, String> _envVars = {};

  /// Load environment variables from .env file (only on non-web platforms)
  static Future<void> load() async {
    // Skip file loading on web platform as it's not supported
    if (kIsWeb) {
      print('Web platform detected. Using default values or compile-time constants.');
      return;
    }

    try {
      final envFile = File('.env');
      if (!await envFile.exists()) {
        print('Warning: .env file not found. Using default values.');
        return;
      }

      final lines = await envFile.readAsLines();
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) {
          continue;
        }

        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          _envVars[key] = value;
        }
      }
    } catch (e) {
      print('Error loading .env file: $e');
    }
  }

  /// Get environment variable value
  static String get(String key, {String? defaultValue}) {
    return _envVars[key] ?? defaultValue ?? '';
  }

  /// Get all environment variables
  static Map<String, String> get all => Map.unmodifiable(_envVars);
}
