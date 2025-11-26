// ========================================
// BOUTON DE DÉCONNEXION
// ========================================

import 'package:flutter/material.dart';

class BoutonDeconnexion extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onLogout;

  const BoutonDeconnexion({
    super.key,
    required this.isDarkMode,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.power_settings_new,
        color: isDarkMode ? const Color(0xFFFF7900) : Colors.black,
      ),
      title: Text(
        'Se déconnecter',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onLogout();
      },
    );
  }
}
