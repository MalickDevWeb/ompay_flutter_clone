import 'package:flutter/material.dart';
import 'bouton_masquage_solde.dart';

class InformationsSolde extends StatelessWidget {
  final bool isDarkMode;
  final bool isSoldeVisible;
  final VoidCallback onToggleSolde;

  const InformationsSolde({
    super.key,
    required this.isDarkMode,
    required this.isSoldeVisible,
    required this.onToggleSolde,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isSoldeVisible ? '0' : '*******',
          style: TextStyle(
            color: isDarkMode ? const Color(0xFFFF7900) : Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: isSoldeVisible ? 0 : 2,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'FCFA',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        BoutonMasquageSolde(
          isDarkMode: isDarkMode,
          isSoldeVisible: isSoldeVisible,
          onToggle: onToggleSolde,
        ),
      ],
    );
  }
}
