import 'package:flutter/material.dart';

class ApiTestDialog extends StatelessWidget {
  final bool isVisible;
  final String? result;
  final VoidCallback onClose;

  const ApiTestDialog({
    super.key,
    required this.isVisible,
    this.result,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: AlertDialog(
            title: const Text('Test API'),
            content: Text(result ?? 'Aucun résultat'),
            actions: [
              TextButton(
                onPressed: onClose,
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
