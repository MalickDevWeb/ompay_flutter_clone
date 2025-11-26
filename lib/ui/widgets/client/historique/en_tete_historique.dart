import 'package:flutter/material.dart';

class EnTeteHistorique extends StatelessWidget {
  final bool isDarkMode;
  final double padding;

  const EnTeteHistorique({
    super.key,
    required this.isDarkMode,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Historique',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              // Naviguer vers l'historique complet
            },
            child: Text(
              'Voir tout',
              style: TextStyle(
                color: const Color(0xFFFF7900),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
