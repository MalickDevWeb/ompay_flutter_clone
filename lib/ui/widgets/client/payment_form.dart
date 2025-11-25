import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentForm extends StatefulWidget {
  final bool isDarkMode;
  final bool isPayerSelected;
  final ValueChanged<bool> onTabChanged;
  final TextEditingController numeroController;
  final TextEditingController montantController;
  final VoidCallback onValidate;

  const PaymentForm({
    super.key,
    required this.isDarkMode,
    required this.isPayerSelected,
    required this.onTabChanged,
    required this.numeroController,
    required this.montantController,
    required this.onValidate,
  });

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: !widget.isDarkMode
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Onglets Payer / Transférer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onTabChanged(true),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: widget.isPayerSelected,
                          onChanged: (value) => widget.onTabChanged(value!),
                          activeColor: const Color(0xFFFF7900),
                        ),
                        Text(
                          'Payer',
                          style: TextStyle(
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: widget.isPayerSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onTabChanged(false),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: widget.isPayerSelected,
                          onChanged: (value) => widget.onTabChanged(value!),
                          activeColor: const Color(0xFFFF7900),
                        ),
                        Text(
                          'Transférer',
                          style: TextStyle(
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: !widget.isPayerSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF7900),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.currency_exchange,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Champs de saisie et image scanner
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champs de formulaire
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: widget.numeroController,
                        style: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: widget.isPayerSelected
                              ? 'Saisir le numéro/code marchand'
                              : 'Saisir le numéro',
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: widget.isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
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
                        controller: widget.montantController,
                        style: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors.black,
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
                          fillColor: widget.isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
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
                // Image scanner à droite
                GestureDetector(
                  onTap: () {
                    // Logique de scan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scanner activé'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 40,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cliquer et\nscanner',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bouton Valider
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onValidate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7900),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Valider',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
