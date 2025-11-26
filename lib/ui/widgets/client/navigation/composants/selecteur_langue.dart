// ========================================
// SÉLECTEUR DE LANGUE
// ========================================

import 'package:flutter/material.dart';

class SelecteurLangue extends StatelessWidget {
  final String selectedLanguage;

  const SelecteurLangue({
    super.key,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language, color: Color(0xFFFF7900)),
      title: Text(
        selectedLanguage,
        style: const TextStyle(
          color: Colors.black, // This widget doesn't have isDarkMode parameter
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: () {
        // Changer la langue
      },
    );
  }
}
