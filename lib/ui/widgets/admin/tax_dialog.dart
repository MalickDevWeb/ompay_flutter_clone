import 'package:flutter/material.dart';

class TaxDialog extends StatefulWidget {
  final Map<String, dynamic> client;
  final bool isDarkMode;
  final Function(String) onApply;

  const TaxDialog({
    super.key,
    required this.client,
    required this.isDarkMode,
    required this.onApply,
  });

  @override
  State<TaxDialog> createState() => _TaxDialogState();
}

class _TaxDialogState extends State<TaxDialog> {
  final TextEditingController taxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      title: Text(
        'Définir une taxe pour ${widget.client['nom']}',
        style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
      ),
      content: TextField(
        controller: taxController,
        keyboardType: TextInputType.number,
        style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'Taxe en %',
          hintStyle: TextStyle(color: Colors.grey[600]),
          suffixText: '%',
          suffixStyle: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600]!),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF7900)),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onApply(taxController.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7900),
          ),
          child: const Text(
            'Appliquer',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
