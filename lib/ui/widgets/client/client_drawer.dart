import 'package:flutter/material.dart';

class ClientDrawer extends StatefulWidget {
  final bool isDarkMode;
  final bool isScannerEnabled;
  final String selectedLanguage;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onScannerChanged;

  const ClientDrawer({
    super.key,
    required this.isDarkMode,
    required this.isScannerEnabled,
    required this.selectedLanguage,
    required this.onDarkModeChanged,
    required this.onScannerChanged,
  });

  @override
  State<ClientDrawer> createState() => _ClientDrawerState();
}

class _ClientDrawerState extends State<ClientDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: widget.isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[200],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode
                              ? const Color(0xFF1C1C1C)
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=OM_PAY_ABDOULAYE',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Abdoulaye Diallo',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '782917770',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text(
              'Sombre',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: widget.isDarkMode,
            onChanged: widget.onDarkModeChanged,
            secondary: const Icon(Icons.brightness_6, color: Color(0xFFFF7900)),
            activeColor: const Color(0xFFFF7900),
          ),
          SwitchListTile(
            title: Text(
              'Scanner',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: widget.isScannerEnabled,
            onChanged: widget.onScannerChanged,
            secondary: const Icon(
              Icons.qr_code_scanner,
              color: Color(0xFFFF7900),
            ),
            activeColor: const Color(0xFFFF7900),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFFFF7900)),
            title: Text(
              widget.selectedLanguage,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () {
              // Changer la langue
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.power_settings_new,
              color: Color(0xFFFF7900),
            ),
            title: Text(
              'Se déconnecter',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              // Déconnexion
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'OMPAY Version - 1.1.0(35)',
              textAlign: TextAlign.center,
              style: TextStyle(color: const Color(0xFFFF7900), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
