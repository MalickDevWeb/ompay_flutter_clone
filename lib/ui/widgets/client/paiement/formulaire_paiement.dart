import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onglets_paiement.dart';
import 'champs_saisie_paiement.dart';
import 'bouton_validation_paiement.dart';

class FormulairePaiement extends StatefulWidget {
  final bool isDarkMode;
  final bool isPayerSelected;
  final ValueChanged<bool> onTabChanged;
  final TextEditingController numeroController;
  final TextEditingController montantController;
  final VoidCallback onValidate;

  const FormulairePaiement({
    super.key,
    required this.isDarkMode,
    required this.isPayerSelected,
    required this.onTabChanged,
    required this.numeroController,
    required this.montantController,
    required this.onValidate,
  });

  @override
  State<FormulairePaiement> createState() => _FormulairePaiementState();
}

class _FormulairePaiementState extends State<FormulairePaiement> {
  bool _isLoading = false;

  Future<void> _handleValidation() async {
    if (widget.numeroController.text.isEmpty || widget.montantController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isPayerSelected ? 'Paiement effectué avec succès' : 'Transfert effectué avec succès',
          ),
          backgroundColor: Colors.green,
        ),
      );

      widget.numeroController.clear();
      widget.montantController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = isSmallScreen ? 16.0 : 20.0;

    return Container(
      margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: !widget.isDarkMode
            ? [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          OngletsPaiement(
            isDarkMode: widget.isDarkMode,
            isPayerSelected: widget.isPayerSelected,
            onTabChanged: widget.onTabChanged,
            padding: padding,
          ),

          ChampsSaisiePaiement(
            isDarkMode: widget.isDarkMode,
            isPayerSelected: widget.isPayerSelected,
            numeroController: widget.numeroController,
            montantController: widget.montantController,
            padding: padding,
          ),

          BoutonValidationPaiement(
            isLoading: _isLoading,
            onPressed: _handleValidation,
            padding: padding,
          ),
        ],
      ),
    );
  }
}

class PaymentTabsWidget extends StatelessWidget {
  final bool isDarkMode;
  final bool isPayerSelected;
  final ValueChanged<bool> onTabChanged;
  final double padding;

  const PaymentTabsWidget({
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
                    Text(
                      'Payer',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: isPayerSelected ? FontWeight.bold : FontWeight.normal,
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
                    Text(
                      'Transférer',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: !isPayerSelected ? FontWeight.bold : FontWeight.normal,
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

class PaymentFieldsWidget extends StatelessWidget {
  final bool isDarkMode;
  final bool isPayerSelected;
  final TextEditingController numeroController;
  final TextEditingController montantController;
  final double padding;

  const PaymentFieldsWidget({
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
          Semantics(
            label: 'Bouton pour scanner un code QR',
            child: GestureDetector(
              onTap: () {
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
          ),
        ],
      ),
    );
  }
}

class PaymentButtonWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final double padding;

  const PaymentButtonWidget({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7900),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Semantics(
            label: 'Valider la transaction',
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
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
    );
  }
}
