// ========================================
// TEXTE DE VERSION SIMPLE
// ========================================

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class TexteVersionSimple extends StatelessWidget {
  final bool isDarkMode;

  const TexteVersionSimple({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'OMPAY Version - 1.1.0(35)',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.icon(isDarkMode),
          fontSize: 12,
        ),
      ),
    );
  }
}
