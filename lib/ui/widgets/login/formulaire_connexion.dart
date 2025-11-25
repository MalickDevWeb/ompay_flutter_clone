// Widget pour afficher le formulaire de connexion en bas de la page
import 'package:flutter/material.dart';

class FormulaireConnexion extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController codeController;
  final bool isCodeStep;
  final String selectedCountryCode;
  final Function(String?) onCountryCodeChanged;
  final Future<void> Function() onButtonPressed;

  const FormulaireConnexion({
    super.key,
    required this.phoneController,
    required this.codeController,
    required this.isCodeStep,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 700,
        width: double.infinity,
        color: const Color(0xFF1C1C1C), // Gris anthracite
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titre de bienvenue
            const Text(
              'Bienvenue sur OM Pay!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Texte d'instruction selon l'étape
            Text(
              isCodeStep
                  ? 'Entrez le code de vérification de 6 chiffres'
                  : 'Entrez votre numéro mobile pour vous connecter',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            // Champ de saisie selon l'étape
            isCodeStep
                ? TextField(
                    controller: codeController,
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
                      // Sélecteur de code pays
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButton<String>(
                          value: selectedCountryCode,
                          items: const [
                            DropdownMenuItem(
                              value: '+221',
                              child: Text('🇸🇳 +221'),
                            ),
                            // Ajouter d'autres si nécessaire
                          ],
                          onChanged: onCountryCodeChanged,
                          underline: const SizedBox(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Champ pour le numéro de téléphone
                      Expanded(
                        child: TextField(
                          controller: phoneController,
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
            // Bouton de connexion/vérification
            ElevatedButton(
              onPressed: () => onButtonPressed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7900),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                isCodeStep ? 'Vérifier' : 'Se connecter',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Texte de copyright
            const Text(
              '© Orange Money tous les droits réservés by Teuw',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
