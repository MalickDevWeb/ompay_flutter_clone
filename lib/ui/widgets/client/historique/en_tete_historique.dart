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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Semantics(
            label: 'Rafraîchir l\'historique',
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                color: const Color(0xFFFF7900),
                size: 20,
              ),
              onPressed: () {
                // Rafraîchir l'historique
              },
            ),
          ),
        ],
      ),
    );
  }
}
