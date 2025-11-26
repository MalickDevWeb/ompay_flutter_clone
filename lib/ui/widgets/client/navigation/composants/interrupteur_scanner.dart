// ========================================
// INTERRUPTEUR SCANNER QR
// ========================================

import 'package:flutter/material.dart';

class InterrupteurScanner extends StatelessWidget {
  final bool isScannerEnabled;
  final ValueChanged<bool> onScannerChanged;

  const InterrupteurScanner({
    super.key,
    required this.isScannerEnabled,
    required this.onScannerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Scanner',
        style: TextStyle(
          color: Colors.black, // This widget doesn't have isDarkMode parameter
        ),
      ),
      value: isScannerEnabled,
      onChanged: onScannerChanged,
      secondary: const Icon(
        Icons.qr_code_scanner,
        color: Color(0xFFFF7900),
      ),
      activeColor: const Color(0xFFFF7900),
    );
  }
}
