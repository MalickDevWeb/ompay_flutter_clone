// ========================================
// INTERRUPTEUR DE THÈME SIMPLE
// ========================================

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class InterrupteurThemeSimple extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const InterrupteurThemeSimple({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Sombre',
        style: TextStyle(
          color: AppColors.textPrimary(isDarkMode),
        ),
      ),
      value: isDarkMode,
      onChanged: onThemeChanged,
      secondary: Icon(Icons.brightness_6, color: AppColors.primary),
      activeThumbColor: AppColors.primary,
    );
  }
}
