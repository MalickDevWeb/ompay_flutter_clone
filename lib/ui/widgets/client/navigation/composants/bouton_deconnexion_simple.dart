// ========================================
// BOUTON DE DÉCONNEXION SIMPLE
// ========================================

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class BoutonDeconnexionSimple extends StatelessWidget {
  final bool isDarkMode;

  const BoutonDeconnexionSimple({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.power_settings_new,
        color: AppColors.icon(isDarkMode),
      ),
      title: Text(
        'Se déconnecter',
        style: TextStyle(
          color: AppColors.textPrimary(isDarkMode),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
