import 'package:flutter/material.dart';

class ClientHeader extends StatelessWidget {
  final bool isDarkMode;
  final bool isSoldeVisible;
  final VoidCallback onToggleSolde;

  const ClientHeader({
    super.key,
    required this.isDarkMode,
    required this.isSoldeVisible,
    required this.onToggleSolde,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bonjour ',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const TextSpan(
                                text: 'Abdoulaye',
                                style: TextStyle(
                                  color: Color(0xFFFF7900),
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
                              isSoldeVisible ? '50000' : '*******',
                              style: TextStyle(
                                color: isDarkMode ? const Color(0xFFFF7900) : Colors.orange[700],
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: isSoldeVisible ? 0 : 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'FCFA',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: onToggleSolde,
                              child: Icon(
                                isSoldeVisible ? Icons.visibility : Icons.visibility_off,
                                color: isDarkMode ? Colors.white : Colors.black,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // QR Code bien aligné
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDarkMode ? Colors.white : Colors.black,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
