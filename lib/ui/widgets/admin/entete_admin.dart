import 'package:flutter/material.dart';

class EnteteAdmin extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onMenuPressed;
  final TabController? tabController;

  const EnteteAdmin({
    super.key,
    required this.isDarkMode,
    required this.onMenuPressed,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: onMenuPressed,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
          ),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7900),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Administration',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Panneau de contrôle',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: TabBar(
        controller: tabController,
        isScrollable: true,
        indicatorColor: const Color(0xFFFF7900),
        tabs: const [
          Tab(text: 'Approbations'),
          Tab(text: 'Clients'),
          Tab(text: 'Frais'),
          Tab(text: 'Stats'),
        ],
      ),
    );
  }
}
