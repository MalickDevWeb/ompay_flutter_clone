import 'package:flutter/material.dart';
import 'modele_compte_utilisateur.dart';
import '../../../../theme/app_colors.dart';

// ========================================
// DIALOGUE POUR CRÉER UN NOUVEAU COMPTE
// ========================================

class DialogueCreationNouveauCompte extends StatefulWidget {
  final bool isDarkMode;
  final Function(AccountModel) onAccountCreated;

  const DialogueCreationNouveauCompte({
    super.key,
    required this.isDarkMode,
    required this.onAccountCreated,
  });

  @override
  State<DialogueCreationNouveauCompte> createState() => _DialogueCreationNouveauCompteState();
}

class _DialogueCreationNouveauCompteState extends State<DialogueCreationNouveauCompte> {
  final TextEditingController _nomController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(widget.isDarkMode),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(
                      color: AppColors.textPrimary(widget.isDarkMode),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _nomController,
              style: TextStyle(
                color: AppColors.textPrimary(widget.isDarkMode),
              ),
              decoration: InputDecoration(
                labelText: 'Nom du compte',
                labelStyle: TextStyle(color: AppColors.textSecondary(widget.isDarkMode)),
                filled: true,
                fillColor: AppColors.card(widget.isDarkMode),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.account_circle, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nomController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez saisir le nom du compte'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final newAccount = AccountModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        numeroCompte: 'CPT-${DateTime.now().millisecondsSinceEpoch}',
                        nomCompte: _nomController.text,
                        isActive: false,
                      );

                      widget.onAccountCreated(newAccount);
                      Navigator.of(context).pop();
                      // Le SnackBar est géré par le parent (_handleAccountCreated)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Créer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
