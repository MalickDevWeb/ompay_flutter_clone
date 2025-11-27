import 'package:flutter/material.dart';

class OngletsPaiement extends StatelessWidget {
  final bool isDarkMode;
  final bool isPayerSelected;
  final ValueChanged<bool> onTabChanged;
  final double padding;

  const OngletsPaiement({
    super.key,
    required this.isDarkMode,
    required this.isPayerSelected,
    required this.onTabChanged,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Option de paiement',
              child: GestureDetector(
                onTap: () => onTabChanged(true),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isPayerSelected,
                      onChanged: (value) => onTabChanged(value!),
                      activeColor: const Color(0xFFFF7900),
                    ),
                    Flexible(
                      child: Text(
                        'Payer',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: isPayerSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Semantics(
              label: 'Option de transfert',
              child: GestureDetector(
                onTap: () => onTabChanged(false),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: isPayerSelected,
                      onChanged: (value) => onTabChanged(value!),
                      activeColor: const Color(0xFFFF7900),
                    ),
                    Flexible(
                      child: Text(
                        'Transférer',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: !isPayerSelected ? FontWeight.bold : FontWeight.normal,
                        ),
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
          ),
        ],
      ),
    );
  }
}
