import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import '../models/api_result.dart';

typedef RequestFunction<T> = Future<T> Function();

class ApiExecutor {
  static final Logger logger = Logger('ApiExecutor');

  /// Safely extracts error message from response data which might be String or Map
  static String _extractErrorMessage(dynamic data, String defaultMessage) {
    if (data == null) return defaultMessage;

    // If data is a Map, try to get the 'message' field
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message != null) return message.toString();
    }

    // If data is a String, use it directly
    if (data is String && data.isNotEmpty) {
      return data;
    }

    return defaultMessage;
  }

  /// Executes a request function and wraps the result in ApiResult.
  /// Handles exceptions and logs success/failure.
  static Future<ApiResult<T>> execute<T>(RequestFunction<T> request) async {
    try {
      final result = await request();
      logger.info('Request executed successfully');
      return ApiResult.success(result);
    } catch (e) {
      String errorMsg;
      if (e is DioException) {
        // Gérer spécifiquement les différents codes d'erreur
        if (e.response?.statusCode == 302) {
          errorMsg = 'Redirection détectée - vérifiez l\'URL de redirection';
          logger.info('Redirection 302 vers: ${e.response?.headers['location']}');
        } else if (e.response?.statusCode == 400) {
          final extractedMsg = _extractErrorMessage(e.response?.data, 'Vérifiez vos informations');
          errorMsg = '400 - Données invalides: $extractedMsg';
        } else if (e.response?.statusCode == 401) {
          final extractedMsg = _extractErrorMessage(e.response?.data, 'Authentification requise');
          errorMsg = '401 - Non autorisé: $extractedMsg';
        } else if (e.response?.statusCode == 500) {
          final extractedMsg = _extractErrorMessage(e.response?.data, 'Problème technique');
          errorMsg = '500 - Erreur serveur: $extractedMsg';
        } else {
          errorMsg = 'Erreur HTTP ${e.response?.statusCode}: ${e.message}';
        }
      } else if (e is SocketException) {
        errorMsg = 'Erreur de connexion réseau: ${e.message}';
      } else if (e is FormatException) {
        errorMsg = 'Erreur d\'analyse des données: ${e.message}';
      } else {
        errorMsg = 'Erreur inattendue: ${e.toString()}';
      }
      logger.fine('Request failed: $errorMsg');
      return ApiResult.failure(errorMsg);
    }
  }
}
