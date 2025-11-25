import 'package:flutter/material.dart';

class OngletClientsAdmin extends StatelessWidget {
  final bool isDarkMode;
  final List<Map<String, dynamic>> activeClients;
  final Function(int) onToggleBanClient;
  final Function(Map<String, dynamic>) onShowTaxDialog;

  const OngletClientsAdmin({
    super.key,
    required this.isDarkMode,
    required this.activeClients,
    required this.onToggleBanClient,
    required this.onShowTaxDialog,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeClients.length,
      itemBuilder: (context, index) {
        final client = activeClients[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: client['isBanned']
                ? Border.all(color: Colors.red, width: 2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: client['isBanned']
                          ? Colors.red.withOpacity(0.2)
                          : const Color(0xFFFF7900).withOpacity(0.2),
                      child: Icon(
                        client['isBanned'] ? Icons.block : Icons.person,
                        color: client['isBanned']
                            ? Colors.red
                            : const Color(0xFFFF7900),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client['nom'],
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            client['telephone'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${client['solde']} FCFA',
                          style: const TextStyle(
                            color: Color(0xFFFF7900),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: client['isBanned']
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            client['isBanned'] ? 'Banni' : client['statut'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => onShowTaxDialog(client),
                        icon: const Icon(Icons.percent, size: 16),
                        label: const Text('Taxe'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF7900),
                          side: const BorderSide(color: Color(0xFFFF7900)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => onToggleBanClient(index),
                        icon: Icon(
                          client['isBanned'] ? Icons.check : Icons.block,
                          size: 16,
                        ),
                        label: Text(client['isBanned'] ? 'Débannir' : 'Bannir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: client['isBanned']
                              ? Colors.green
                              : Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
      },
    );
  }
}
