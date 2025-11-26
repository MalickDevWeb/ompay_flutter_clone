import 'package:flutter/material.dart';

class BoutonMasquageSolde extends StatelessWidget {
  final bool isDarkMode;
  final bool isSoldeVisible;
  final VoidCallback onToggle;

  const BoutonMasquageSolde({
    super.key,
    required this.isDarkMode,
    required this.isSoldeVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isSoldeVisible ? 'Masquer le solde' : 'Afficher le solde',
      child: GestureDetector(
        onTap: onToggle,
        child: Icon(
          isSoldeVisible ? Icons.visibility : Icons.visibility_off,
          color: isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
