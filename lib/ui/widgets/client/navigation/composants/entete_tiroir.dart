// ========================================
// EN-TÊTE DU TIROIR DE NAVIGATION
// ========================================

import 'package:flutter/material.dart';
import '../../../../../../models/entities/user_model.dart';

class EnteteTiroir extends StatelessWidget {
  final bool isDarkMode;
  final UserModel? user;

  const EnteteTiroir({
    super.key,
    required this.isDarkMode,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: const NetworkImage(
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
            ),
            onBackgroundImageError: (_, __) => const Icon(
              Icons.person,
              size: 50,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.name ?? 'Utilisateur',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.telephone ?? 'Chargement...',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
