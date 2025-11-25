/// Utility functions for converting technical errors to user-friendly messages
class ErrorMessageUtils {
  /// Converts technical error messages to user-friendly French messages
  static String getUserFriendlyError(dynamic error) {
    if (error == null) {
      return '❌ Une erreur inattendue s\'est produite.';
    }

    final errorStr = error.toString().toLowerCase();

    // Network and timeout errors
    if (errorStr.contains('timeout') ||
        errorStr.contains('receive data') ||
        errorStr.contains('connection timed out')) {
      return '⏱️ Connexion lente. Vérifiez votre connexion internet et réessayez.';
    }

    // Network connectivity errors
    if (errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('socket') ||
        errorStr.contains('host unreachable')) {
      return '🌐 Problème de connexion. Vérifiez votre connexion internet.';
    }

    // HTTP status codes
    if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
      return '🔐 Identifiants incorrects. Vérifiez votre numéro de téléphone.';
    }

    if (errorStr.contains('403') || errorStr.contains('forbidden')) {
      return '🚫 Accès refusé. Vous n\'avez pas les permissions nécessaires.';
    }

    if (errorStr.contains('404') || errorStr.contains('not found')) {
      return '👤 Utilisateur non trouvé. Vérifiez vos informations.';
    }

    if (errorStr.contains('422') || errorStr.contains('unprocessable')) {
      return '📝 Données invalides. Vérifiez les informations saisies.';
    }

    if (errorStr.contains('429') || errorStr.contains('too many requests')) {
      return '🐌 Trop de tentatives. Veuillez patienter avant de réessayer.';
    }

    if (errorStr.contains('500') || errorStr.contains('internal server error')) {
      return '🔧 Service temporairement indisponible. Réessayez plus tard.';
    }

    if (errorStr.contains('502') || errorStr.contains('bad gateway')) {
      return '🌉 Problème de serveur. Réessayez dans quelques instants.';
    }

    if (errorStr.contains('503') || errorStr.contains('service unavailable')) {
      return '🏗️ Service en maintenance. Réessayez plus tard.';
    }

    // JSON parsing errors
    if (errorStr.contains('json') || errorStr.contains('parsing')) {
      return '📡 Données reçues invalides. Réessayez.';
    }

    // OTP specific errors
    if (errorStr.contains('otp') || errorStr.contains('code')) {
      return '🔢 Code OTP invalide ou expiré. Demandez un nouveau code.';
    }

    // Default fallback
    return '❌ Une erreur inattendue s\'est produite. Veuillez réessayer.';
  }

  /// Validates menu choice input
  static String? validateMenuChoice(String? input) {
    if (input == null || input.trim().isEmpty) {
      return '❌ Saisie vide. Veuillez entrer un numéro.';
    }

    final trimmed = input.trim();

    // Check if it's a valid number
    final choice = int.tryParse(trimmed);
    if (choice == null) {
      return '❌ Veuillez entrer un numéro valide (1-4).';
    }

    // Check if it's in valid range
    if (choice < 1 || choice > 4) {
      return '❌ Option invalide. Choisissez entre 1 et 4.';
    }

    return null; // Valid input
  }
}
