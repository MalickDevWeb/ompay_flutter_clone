// ========================================
// EN-TÊTE DU TIROIR SIMPLE
// ========================================

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../../../models/entities/compte_model.dart';
import '../../../../../../models/entities/user_model.dart';

class EnteteTiroirSimple extends StatelessWidget {
  final bool isDarkMode;
  final UserModel? user;
  final CompteModel? activeAccount;

  const EnteteTiroirSimple({
    super.key,
    required this.isDarkMode,
    this.user,
    this.activeAccount,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: AppColors.card(isDarkMode),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.lightSurface,
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                ),
                onBackgroundImageError: (_, _) => Icon(
                  Icons.person,
                  size: 35,
                  color: AppColors.textTertiary(isDarkMode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      activeAccount?.nomCompte ?? user?.nom ?? 'Utilisateur', // Nom du compte actif ou nom utilisateur
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activeAccount?.numeroCompte ?? 'Chargement...', // Numéro du compte actif
                      style: TextStyle(
                        color: AppColors.textSecondary(isDarkMode),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
