import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Centralized error handling system for the application
class ErrorHandler {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Error types for better categorization
  static const String NETWORK_ERROR = 'NETWORK_ERROR';
  static const String AUTHENTICATION_ERROR = 'AUTHENTICATION_ERROR';
  static const String VALIDATION_ERROR = 'VALIDATION_ERROR';
  static const String SERVER_ERROR = 'SERVER_ERROR';
  static const String UNKNOWN_ERROR = 'UNKNOWN_ERROR';
  static const String OFFLINE_ERROR = 'OFFLINE_ERROR';

  /// Handle and categorize errors
  static ErrorInfo categorizeError(dynamic error, {StackTrace? stackTrace}) {
    String type = UNKNOWN_ERROR;
    String userMessage = 'Une erreur inattendue s\'est produite';
    String? technicalMessage;

    if (error is Exception) {
      final errorString = error.toString().toLowerCase();

      if (errorString.contains('socket') ||
          errorString.contains('connection') ||
          errorString.contains('timeout') ||
          errorString.contains('network')) {
        type = NETWORK_ERROR;
        userMessage = 'Problème de connexion réseau. Vérifiez votre connexion internet.';
      } else if (errorString.contains('401') ||
          errorString.contains('unauthorized') ||
          errorString.contains('token')) {
        type = AUTHENTICATION_ERROR;
        userMessage = 'Session expirée. Veuillez vous reconnecter.';
      } else if (errorString.contains('400') ||
          errorString.contains('validation')) {
        type = VALIDATION_ERROR;
        userMessage = 'Données invalides. Vérifiez vos informations.';
      } else if (errorString.contains('500') ||
          errorString.contains('server')) {
        type = SERVER_ERROR;
        userMessage = 'Erreur du serveur. Réessayez plus tard.';
      }
    }

    technicalMessage = error.toString();

    // Log the error
    _logError(type, error, stackTrace, technicalMessage);

    return ErrorInfo(
      type: type,
      userMessage: userMessage,
      technicalMessage: technicalMessage,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Show user-friendly error message
  static void showErrorSnackBar(BuildContext context, dynamic error, {StackTrace? stackTrace}) {
    final errorInfo = categorizeError(error, stackTrace: stackTrace);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorInfo.userMessage),
        backgroundColor: _getErrorColor(errorInfo.type),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Détails',
          textColor: Colors.white,
          onPressed: () => _showErrorDetailsDialog(context, errorInfo),
        ),
      ),
    );
  }

  /// Show detailed error dialog for debugging
  static void _showErrorDetailsDialog(BuildContext context, ErrorInfo errorInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails de l\'erreur'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type: ${errorInfo.type}'),
              const SizedBox(height: 8),
              Text('Message: ${errorInfo.userMessage}'),
              const SizedBox(height: 8),
              const Text('Détails techniques:'),
              Text(
                errorInfo.technicalMessage ?? 'N/A',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  /// Get appropriate color for error type
  static Color _getErrorColor(String errorType) {
    switch (errorType) {
      case NETWORK_ERROR:
      case OFFLINE_ERROR:
        return Colors.orange;
      case AUTHENTICATION_ERROR:
        return Colors.red;
      case VALIDATION_ERROR:
        return Colors.amber;
      case SERVER_ERROR:
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  /// Log error with appropriate level
  static void _logError(String type, dynamic error, StackTrace? stackTrace, String? technicalMessage) {
    final message = '[ERROR_HANDLER] $type: $technicalMessage';

    switch (type) {
      case NETWORK_ERROR:
      case OFFLINE_ERROR:
        _logger.w(message, error: error, stackTrace: stackTrace);
        break;
      case AUTHENTICATION_ERROR:
        _logger.i(message, error: error, stackTrace: stackTrace);
        break;
      case SERVER_ERROR:
        _logger.e(message, error: error, stackTrace: stackTrace);
        break;
      default:
        _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Handle async operations with error handling
  static Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? operationName,
    bool showSnackBar = true,
    BuildContext? context,
  }) async {
    try {
      _logger.d('Starting operation: ${operationName ?? 'Unknown'}');
      final result = await operation();
      _logger.d('Operation completed successfully: ${operationName ?? 'Unknown'}');
      return result;
    } catch (error, stackTrace) {
      _logger.e('Operation failed: ${operationName ?? 'Unknown'}', error: error, stackTrace: stackTrace);

      if (showSnackBar && context != null) {
        showErrorSnackBar(context, error, stackTrace: stackTrace);
      }

      return null;
    }
  }
}

/// Error information container
class ErrorInfo {
  final String type;
  final String userMessage;
  final String? technicalMessage;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const ErrorInfo({
    required this.type,
    required this.userMessage,
    this.technicalMessage,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'ErrorInfo(type: $type, userMessage: $userMessage, technicalMessage: $technicalMessage)';
  }
}
