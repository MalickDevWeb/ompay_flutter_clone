import 'package:flutter/material.dart';

/// ========================================
/// SYSTÈME DE COULEURS UNIFIÉ DE L'APPLICATION
/// Basé sur les couleurs de l'admin (correctes et lisibles)
/// ========================================

class AppColors {
  // ========================================
  // COULEURS PRINCIPALES (BRAND)
  // ========================================

  /// Couleur principale de l'application (Orange)
  static const Color primary = Color(0xFFFF7900);

  /// Couleur secondaire (Vert pour les actions positives)
  static const Color secondary = Color(0xFF4CAF50);

  /// Couleur d'accentuation (Rouge pour les erreurs)
  static const Color accent = Color(0xFFF44336);

  // ========================================
  // COULEURS DE FOND
  // ========================================

  /// Fond sombre principal
  static const Color darkBackground = Color(0xFF0A0A0A);

  /// Surface sombre (cartes, tiroirs)
  static const Color darkSurface = Color(0xFF1C1C1C);

  /// Surface sombre secondaire (éléments surélevés)
  static const Color darkCard = Color(0xFF2A2A2A);

  /// Fond clair principal
  static const Color lightBackground = Color(0xFFF5F5F5);

  /// Surface claire (cartes, tiroirs)
  static const Color lightSurface = Colors.white;

  /// Fond gris clair (headers alternatifs)
  static const Color lightHeader = Color(0xFFE0E0E0);

  // ========================================
  // COULEURS DE TEXTE
  // ========================================

  /// Texte principal sombre
  static const Color textPrimaryDark = Colors.white;

  /// Texte secondaire sombre
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  /// Texte tertiaire sombre
  static const Color textTertiaryDark = Color(0xFF808080);

  /// Texte principal clair
  static const Color textPrimaryLight = Colors.black;

  /// Texte secondaire clair
  static const Color textSecondaryLight = Color(0xFF666666);

  /// Texte tertiaire clair
  static const Color textTertiaryLight = Color(0xFF999999);

  // ========================================
  // COULEURS DE STATUT
  // ========================================

  /// Succès (approbation, validation)
  static const Color success = Color(0xFF4CAF50);

  /// Erreur (rejet, échec)
  static const Color error = Color(0xFFF44336);

  /// Avertissement (attention)
  static const Color warning = Color(0xFFFF9800);

  /// Information (neutre)
  static const Color info = Color(0xFF2196F3);

  // ========================================
  // COULEURS DE THÈME DYNAMIQUES
  // ========================================

  /// Retourne la couleur de fond selon le thème
  static Color background(bool isDarkMode) {
    return isDarkMode ? darkBackground : lightBackground;
  }

  /// Retourne la couleur de surface selon le thème
  static Color surface(bool isDarkMode) {
    return isDarkMode ? darkSurface : lightSurface;
  }

  /// Retourne la couleur de carte selon le thème
  static Color card(bool isDarkMode) {
    return isDarkMode ? darkCard : lightSurface;
  }

  /// Retourne la couleur de texte principal selon le thème
  static Color textPrimary(bool isDarkMode) {
    return isDarkMode ? textPrimaryDark : textPrimaryLight;
  }

  /// Retourne la couleur de texte secondaire selon le thème
  static Color textSecondary(bool isDarkMode) {
    return isDarkMode ? textSecondaryDark : textSecondaryLight;
  }

  /// Retourne la couleur de texte tertiaire selon le thème
  static Color textTertiary(bool isDarkMode) {
    return isDarkMode ? textTertiaryDark : textTertiaryLight;
  }

  /// Retourne la couleur d'icône selon le thème (pour visibilité)
  static Color icon(bool isDarkMode) {
    return isDarkMode ? primary : textPrimaryLight;
  }

  /// Retourne la couleur d'icône secondaire selon le thème
  static Color iconSecondary(bool isDarkMode) {
    return isDarkMode ? textSecondaryDark : textSecondaryLight;
  }

  // ========================================
  // COULEURS SPÉCIALISÉES
  // ========================================

  /// Couleur pour les éléments actifs/sélectionnés
  static const Color active = primary;

  /// Couleur pour les éléments inactifs
  static const Color inactive = Color(0xFF666666);

  /// Couleur pour les bordures
  static Color border(bool isDarkMode) {
    return isDarkMode ? Color(0xFF404040) : Color(0xFFE0E0E0);
  }

  /// Couleur pour les diviseurs
  static Color divider(bool isDarkMode) {
    return isDarkMode ? Color(0xFF404040) : Color(0xFFE0E0E0);
  }

  /// Couleur pour les ombres
  static Color shadow(bool isDarkMode) {
    return isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1);
  }
}
