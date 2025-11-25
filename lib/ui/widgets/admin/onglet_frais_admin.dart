import 'package:flutter/material.dart';

class OngletFraisAdmin extends StatelessWidget {
  final bool isDarkMode;
  final double transferFee;
  final double withdrawalFee;
  final double paymentFee;
  final Function(double) onTransferFeeChanged;
  final Function(double) onWithdrawalFeeChanged;
  final Function(double) onPaymentFeeChanged;
  final VoidCallback onSaveFees;

  const OngletFraisAdmin({
    super.key,
    required this.isDarkMode,
    required this.transferFee,
    required this.withdrawalFee,
    required this.paymentFee,
    required this.onTransferFeeChanged,
    required this.onWithdrawalFeeChanged,
    required this.onPaymentFeeChanged,
    required this.onSaveFees,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration des frais globaux',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeeCard(
            'Frais de transfert',
            Icons.currency_exchange,
            transferFee,
            onTransferFeeChanged,
          ),
          const SizedBox(height: 12),
          _buildFeeCard(
            'Frais de retrait',
            Icons.account_balance_wallet,
            withdrawalFee,
            onWithdrawalFeeChanged,
          ),
          const SizedBox(height: 12),
          _buildFeeCard(
            'Frais de paiement',
            Icons.payment,
            paymentFee,
            onPaymentFeeChanged,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSaveFees,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7900),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sauvegarder les frais',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeCard(
    String title,
    IconData icon,
    double value,
    Function(double) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7900).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFFFF7900)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Color(0xFFFF7900),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 40,
            activeColor: const Color(0xFFFF7900),
            label: '${value.toStringAsFixed(1)}%',
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
