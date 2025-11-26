import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bouton_scan_qr.dart';

class ChampsSaisiePaiement extends StatelessWidget {
  final bool isDarkMode;
  final bool isPayerSelected;
  final TextEditingController numeroController;
  final TextEditingController montantController;
  final double padding;

  const ChampsSaisiePaiement({
    super.key,
    required this.isDarkMode,
    required this.isPayerSelected,
    required this.numeroController,
    required this.montantController,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: numeroController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: isPayerSelected
                        ? 'Saisir le numéro/code marchand'
                        : 'Saisir le numéro',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF2A2A2A)
                        : Colors.grey[100],
                    suffixIcon: Icon(
                      Icons.person_outline,
                      color: const Color(0xFFFF7900),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: montantController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: 'Saisir le montant',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF2A2A2A)
                        : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          BoutonScanQR(isDarkMode: isDarkMode),
        ],
      ),
    );
  }
}
