// ========================================
// INTERRUPTEUR DE THÈME (CLAIR/SOMBRE)
// ========================================

import 'package:flutter/material.dart';

class InterrupteurTheme extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const InterrupteurTheme({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Sombre',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      value: isDarkMode,
      onChanged: onDarkModeChanged,
      secondary: const Icon(Icons.brightness_6, color: Color(0xFFFF7900)),
      activeColor: const Color(0xFFFF7900),
    );
  }
}
