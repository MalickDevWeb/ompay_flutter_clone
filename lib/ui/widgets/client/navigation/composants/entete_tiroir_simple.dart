// ========================================
// EN-TÊTE DU TIROIR SIMPLE
// ========================================

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class EnteteTiroirSimple extends StatelessWidget {
  final bool isDarkMode;

  const EnteteTiroirSimple({super.key, required this.isDarkMode});

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
                      'Abdoulaye Diallo',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDarkMode),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '782917770',
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
