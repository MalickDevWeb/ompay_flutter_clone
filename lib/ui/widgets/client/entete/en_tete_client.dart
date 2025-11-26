import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class EnTeteClient extends StatelessWidget {
  final bool isDarkMode;
  final bool isSoldeVisible;
  final VoidCallback onToggleSolde;
  final String? userName;
  final double? balance;

  const EnTeteClient({
    super.key,
    required this.isDarkMode,
    required this.isSoldeVisible,
    required this.onToggleSolde,
    this.userName,
    this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return SliverAppBar(
      expandedHeight: isSmallScreen ? 200 : 220,
      pinned: true,
      backgroundColor: AppColors.surface(isDarkMode),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: AppColors.icon(isDarkMode),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDarkMode),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 16 : 20,
              isSmallScreen ? 60 : 70,
              isSmallScreen ? 16 : 20,
              isSmallScreen ? 16 : 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Bonjour ',
                              style: TextStyle(
                                color: AppColors.textPrimary(isDarkMode),
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: userName ?? 'Utilisateur',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            isSoldeVisible ? (balance?.toStringAsFixed(0) ?? '0') : '*******',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: isSoldeVisible ? 0 : 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'FCFA',
                            style: TextStyle(
                              color: AppColors.textPrimary(isDarkMode),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Semantics(
                            label: isSoldeVisible ? 'Masquer le solde' : 'Afficher le solde',
                            child: GestureDetector(
                              onTap: onToggleSolde,
                              child: Icon(
                                isSoldeVisible ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.icon(isDarkMode),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label: 'Code QR personnel pour les paiements',
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.icon(isDarkMode),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=OM_PAY_ABDOULAYE',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.white,
                          child: const Icon(Icons.qr_code, size: 60),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
