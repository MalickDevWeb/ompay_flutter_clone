import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Supported languages
enum AppLanguage {
  french('fr', 'Français'),
  english('en', 'English');

  const AppLanguage(this.code, this.name);
  final String code;
  final String name;
}

/// Localization service for managing app language
class LocalizationService {
  static const AppLanguage defaultLanguage = AppLanguage.french;

  static const List<Locale> supportedLocales = [
    Locale('fr', 'FR'),
    Locale('en', 'US'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Get localized strings
  static AppLocalizations get strings => AppLocalizations.instance;
}

/// App localizations class
class AppLocalizations {
  static final AppLocalizations instance = AppLocalizations._();

  AppLocalizations._();

  /// Common strings
  String get appName => _getString('OMPAY');
  String get login => _getString('Connexion');
  String get logout => _getString('Se déconnecter');
  String get loading => _getString('Chargement...');
  String get error => _getString('Erreur');
  String get retry => _getString('Réessayer');
  String get cancel => _getString('Annuler');
  String get confirm => _getString('Confirmer');
  String get ok => _getString('OK');

  // Authentication
  String get welcome => _getString('Bienvenue');
  String get enterPhone => _getString('Entrez votre numéro');
  String get enterOtp => _getString('Entrez le code OTP');
  String get invalidPhone => _getString('Numéro invalide');
  String get invalidOtp => _getString('Code OTP invalide');
  String get loginSuccess => _getString('Connexion réussie');
  String get loginFailed => _getString('Échec de connexion');

  // Dashboard
  String get balance => _getString('Solde');
  String get transactions => _getString('Transactions');
  String get transfer => _getString('Transférer');
  String get pay => _getString('Payer');
  String get deposit => _getString('Dépôt');
  String get withdraw => _getString('Retirer');

  // Settings
  String get settings => _getString('Paramètres');
  String get darkMode => _getString('Mode sombre');
  String get lightMode => _getString('Mode clair');
  String get language => _getString('Langue');
  String get scanner => _getString('Scanner');
  String get notifications => _getString('Notifications');

  // Error messages
  String get networkError => _getString('Erreur de réseau');
  String get serverError => _getString('Erreur du serveur');
  String get unknownError => _getString('Erreur inconnue');
  String get sessionExpired => _getString('Session expirée');

  // Transaction types
  String get transactionDeposit => _getString('Dépôt effectué');
  String get transactionWithdrawal => _getString('Retrait d\'argent');
  String get transactionTransfer => _getString('Transfert d\'argent');
  String get transactionPurchase => _getString('Achat virtuel');

  /// Get string based on current language
  String _getString(String frenchText, [String? englishText]) {
    // For now, return French by default
    // TODO: Implement dynamic language switching
    return frenchText;
  }

  /// Format currency
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0)} FCFA';
  }

  /// Format date
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return _getString('Hier');
    } else if (difference.inDays < 7) {
      return '${difference.inDays}j';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    }
  }

  /// Get transaction type label
  String getTransactionTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'depot':
      case 'dépôt':
        return transactionDeposit;
      case 'retrait':
        return transactionWithdrawal;
      case 'transfert':
        return transactionTransfer;
      case 'achat':
      case 'achat_virtuel':
        return transactionPurchase;
      default:
        return type;
    }
  }
}
