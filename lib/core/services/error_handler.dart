import 'package:flutter/material.dart';
import 'package:test_flutter/core/services/logging_service.dart';

/// Types of errors that can occur in the application
enum ErrorType {
  network,
  authentication,
  validation,
  server,
  unknown,
}

/// Centralized error handling service
class ErrorHandler {
  /// Handle async operations with error handling
  static Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String operationName = 'Operation',
    BuildContext? context,
    bool showSnackBar = true,
  }) async {
    try {
      final result = await operation();
      LoggingService.debug('$operationName completed successfully');
      return result;
    } catch (error, stackTrace) {
      LoggingService.error('$operationName failed', error: error, stackTrace: stackTrace);

      if (context != null && showSnackBar) {
        showErrorSnackBar(context, error, stackTrace: stackTrace);
      }

      return null;
    }
  }

  /// Show error snackbar with user-friendly message
  static void showErrorSnackBar(
    BuildContext context,
    dynamic error, {
    StackTrace? stackTrace,
    String? customMessage,
  }) {
    final errorMessage = _getErrorMessage(error, customMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Log the error for debugging
    LoggingService.error('Error shown to user: $errorMessage', error: error, stackTrace: stackTrace);
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );

    LoggingService.info('Success message shown: $message');
  }

  /// Show info snackbar
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: duration,
      ),
    );

    LoggingService.info('Info message shown: $message');
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, {String message = 'Chargement...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Get user-friendly error message from error object
  static String _getErrorMessage(dynamic error, String? customMessage) {
    if (customMessage != null) {
      return customMessage;
    }

    if (error is String) {
      return error;
    }

    // Handle specific error types
    if (error.toString().contains('SocketException') ||
        error.toString().contains('Network') ||
        error.toString().contains('connection')) {
      return 'Erreur de connexion réseau. Vérifiez votre connexion internet.';
    }

    if (error.toString().contains('401') ||
        error.toString().contains('Unauthorized') ||
        error.toString().contains('authentication')) {
      return 'Session expirée. Veuillez vous reconnecter.';
    }

    if (error.toString().contains('403') ||
        error.toString().contains('Forbidden')) {
      return 'Accès refusé. Vous n\'avez pas les permissions nécessaires.';
    }

    if (error.toString().contains('404') ||
        error.toString().contains('Not Found')) {
      return 'Service non disponible. Réessayez plus tard.';
    }

    if (error.toString().contains('500') ||
        error.toString().contains('Server Error')) {
      return 'Erreur du serveur. Nos équipes ont été notifiées.';
    }

    if (error.toString().contains('Timeout')) {
      return 'Délai d\'attente dépassé. Réessayez.';
    }

    // Default error message
    return 'Une erreur inattendue s\'est produite. Réessayez.';
  }

  /// Categorize error type
  static ErrorType categorizeError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return ErrorType.network;
    }

    if (errorString.contains('401') ||
        errorString.contains('403') ||
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden') ||
        errorString.contains('authentication')) {
      return ErrorType.authentication;
    }

    if (errorString.contains('validation') ||
        errorString.contains('invalid') ||
        errorString.contains('required')) {
      return ErrorType.validation;
    }

    if (errorString.contains('500') ||
        errorString.contains('server') ||
        errorString.contains('internal')) {
      return ErrorType.server;
    }

    return ErrorType.unknown;
  }

  /// Handle error based on type
  static void handleErrorByType(
    BuildContext context,
    dynamic error, {
    StackTrace? stackTrace,
    ErrorType? errorType,
  }) {
    final type = errorType ?? categorizeError(error);

    switch (type) {
      case ErrorType.network:
        showErrorSnackBar(
          context,
          error,
          customMessage: 'Problème de connexion. Vérifiez votre réseau.',
          stackTrace: stackTrace,
        );
        break;

      case ErrorType.authentication:
        showErrorSnackBar(
          context,
          error,
          customMessage: 'Session expirée. Reconnexion requise.',
          stackTrace: stackTrace,
        );
        // Could trigger logout here
        break;

      case ErrorType.validation:
        showErrorSnackBar(
          context,
          error,
          customMessage: 'Données invalides. Vérifiez vos informations.',
          stackTrace: stackTrace,
        );
        break;

      case ErrorType.server:
        showErrorSnackBar(
          context,
          error,
          customMessage: 'Service temporairement indisponible.',
          stackTrace: stackTrace,
        );
        break;

      case ErrorType.unknown:
      default:
        showErrorSnackBar(context, error, stackTrace: stackTrace);
        break;
    }
  }

  /// Log error with context
  static void logError(
    String message,
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) {
    LoggingService.logErrorWithContext(
      message,
      error,
      stackTrace: stackTrace,
      additionalData: additionalData,
    );
  }

  /// Create error report for support
  static Map<String, dynamic> createErrorReport(
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'context': context,
      'deviceInfo': {
        'platform': 'Flutter',
        // Add more device info as needed
      },
    };
  }
}
