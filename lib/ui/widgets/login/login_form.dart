import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/presentation/providers/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          authProvider.isCodeStep
              ? 'Entrez le code de vérification de 6 chiffres'
              : 'Entrez votre numéro mobile pour vous connecter',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 20),
        authProvider.isCodeStep
            ? TextField(
                controller: _codeController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                ),
                decoration: const InputDecoration(
                  hintText: '000000',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Text('+221'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Numéro de téléphone',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (authProvider.isCodeStep) {
              authProvider.authenticate(_codeController.text);
              if (authProvider.currentUser != null) {
                // Navigation will be handled by the page
              }
            } else {
              authProvider.startPhoneVerification(_phoneController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7900),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: Text(
            authProvider.isCodeStep ? 'Vérifier' : 'Se connecter',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '© Orange Money tous les droits réservés by Teuw',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
