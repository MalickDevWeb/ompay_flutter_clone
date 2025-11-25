import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FournisseurPage extends StatefulWidget {
  const FournisseurPage({super.key});

  @override
  State<FournisseurPage> createState() => _FournisseurPageState();
}

class _FournisseurPageState extends State<FournisseurPage> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _montantDemandeController =
      TextEditingController();
  final TextEditingController _raisonController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSoldeVisible = false;
  bool _isDarkMode = true;
  int _selectedIndex = 0; // 0: Dépôt, 1: Demande

  final String solde = '150 000';
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'Dépôt effectué',
      'subtitle': 'Client: 771234567',
      'amount': '- 50 000 CFA',
      'date': '20/11 18:30',
      'icon': Icons.upload,
      'isPositive': false,
    },
    {
      'type': 'Demande approuvée',
      'subtitle': 'Admin',
      'amount': '+ 200 000 CFA',
      'date': '19/11 14:20',
      'icon': Icons.check_circle,
      'isPositive': true,
    },
  ];

  final List<Map<String, dynamic>> _demandesEnCours = [
    {
      'montant': '500 000 CFA',
      'raison': 'Réapprovisionnement mensuel',
      'date': '21/11 09:00',
      'statut': 'En attente',
      'couleur': Colors.orange,
    },
    {
      'montant': '200 000 CFA',
      'raison': 'Urgence - Forte demande',
      'date': '15/11 16:45',
      'statut': 'Approuvée',
      'couleur': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Bonjour ',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const TextSpan(
                    text: 'Fournisseur',
                    style: TextStyle(
                      color: Color(0xFFFF7900),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'FOURNISSEUR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=FOURNISSEUR_OM',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[200],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.storefront,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fournisseur OM',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'ID: 782917770',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: Text(
                'Mode sombre',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              value: _isDarkMode,
              onChanged: (v) => setState(() => _isDarkMode = v),
              secondary: const Icon(Icons.dark_mode, color: Color(0xFFFF7900)),
              activeColor: const Color(0xFFFF7900),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Se déconnecter',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
              child: Row(
                children: [
                  Text(
                    _isSoldeVisible ? solde : '*******',
                    style: TextStyle(
                      color: const Color(0xFFFF7900),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'FCFA',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isSoldeVisible ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _isSoldeVisible = !_isSoldeVisible),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton('Dépôt', Icons.upload, 0)),
                  Expanded(
                    child: _buildTabButton('Demander', Icons.request_quote, 1),
                  ),
                ],
              ),
            ),
            if (_selectedIndex == 0) _buildDepotSection(),
            if (_selectedIndex == 1) _buildDemandeSection(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Historique',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFFFF7900)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            _buildTransactionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7900) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (_isDarkMode ? Colors.white : Colors.black),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (_isDarkMode ? Colors.white : Colors.black),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepotSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildTextField(
            _numeroController,
            'Numéro du client',
            'Ex: 771234567',
            Icons.phone,
            TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            _montantController,
            'Montant à déposer',
            'Ex: 50000',
            Icons.attach_money,
            TextInputType.number,
            suffix: 'FCFA',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleDepot,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7900),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Effectuer le dépôt',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemandeSection() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildTextField(
                _montantDemandeController,
                'Montant demandé',
                'Ex: 500000',
                Icons.account_balance_wallet,
                TextInputType.number,
                suffix: 'FCFA',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _raisonController,
                maxLines: 3,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Raison',
                  hintText: 'Ex: Réapprovisionnement...',
                  filled: true,
                  fillColor: _isDarkMode
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleDemande,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Envoyer la demande',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Demandes en cours',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: _demandesEnCours.length,
          itemBuilder: (context, index) {
            final d = _demandesEnCours[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: d['couleur'], width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        d['montant'],
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: d['couleur'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          d['statut'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    d['raison'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    d['date'],
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
    TextInputType type, {
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      inputFormatters:
          type == TextInputType.number || type == TextInputType.phone
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFFF7900)),
        suffixText: suffix,
        filled: true,
        fillColor: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _handleDepot() {
    if (_numeroController.text.isEmpty || _montantController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Remplissez tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer'),
        content: Text(
          'Déposer ${_montantController.text} FCFA au ${_numeroController.text} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dépôt effectué'),
                  backgroundColor: Colors.green,
                ),
              );
              _numeroController.clear();
              _montantController.clear();
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _handleDemande() {
    if (_montantDemandeController.text.isEmpty ||
        _raisonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Remplissez tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer'),
        content: Text('Demander ${_montantDemandeController.text} FCFA ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Demande envoyée'),
                  backgroundColor: Colors.green,
                ),
              );
              _montantDemandeController.clear();
              _raisonController.clear();
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final t = _transactions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(t['icon'], size: 22),
            ),
            title: Text(
              t['type'],
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              t['subtitle'],
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  t['amount'],
                  style: TextStyle(
                    color: t['isPositive'] ? Colors.green : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  t['date'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
