// ========================================
// TEXTE DE VERSION DE L'APPLICATION
// ========================================

import 'package:flutter/material.dart';

class TexteVersion extends StatelessWidget {
  final bool isDarkMode;

  const TexteVersion({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'OMPAY Version - 1.1.0(35)',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDarkMode ? const Color(0xFFFF7900) : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}
