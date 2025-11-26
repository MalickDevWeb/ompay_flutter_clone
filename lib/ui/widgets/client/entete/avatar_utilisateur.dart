import 'package:flutter/material.dart';

class AvatarUtilisateur extends StatelessWidget {
  final bool isDarkMode;

  const AvatarUtilisateur({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Code QR personnel pour les paiements',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? Colors.white : Colors.black,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Image.network(
          'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=OM_PAY_ABDOULAYE',
          width: 80,
          height: 80,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 80,
              color: Colors.white,
              child: const Icon(Icons.qr_code, size: 60),
            );
          },
        ),
      ),
    );
  }
}
