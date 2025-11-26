import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ========================================
// PAGE D'ACCUEIL AVEC AUDIT FRONTEND COMPLET
// ========================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPayerSelected = true;
  bool _isSoldeVisible = false;
  bool _isDarkMode = true;
  bool _isLoading = false;

  // Données fictives pour l'historique
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'Transfert d\'argent',
      'subtitle': 'Djeuli ODC',
      'amount': '- 2 CFA',
      'date': '17/11 16:49',
      'icon': Icons.phone_android,
      'isPositive': false,
    },
    {
      'type': 'Retrait d\'argent',
      'subtitle': '786284027',
      'amount': '- 20 000 CFA',
      'date': '11/11 20:01',
      'icon': Icons.account_balance_wallet,
      'isPositive': false,
    },
    {
      'type': 'Retrait d\'argent',
      'subtitle': '786284027',
      'amount': '+ 20 000 CFA',
      'date': '10/11 15:30',
      'icon': Icons.account_balance_wallet,
      'isPositive': true,
    },
  ];

  @override
  void dispose() {
    _numeroController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _handleValidation() async {
    if (_numeroController.text.isEmpty || _montantController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulation d'une opération API
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isPayerSelected ? 'Paiement effectué avec succès' : 'Transfert effectué avec succès',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Réinitialiser les champs après succès
      _numeroController.clear();
      _montantController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final padding = isSmallScreen ? 16.0 : 20.0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[100],
      drawer: _buildDrawer(),
      body: CustomScrollView(
        slivers: [
          // AppBar avec header responsive
          SliverAppBar(
            expandedHeight: isSmallScreen ? 180 : 200,
            pinned: true,
            backgroundColor: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(padding, 60, padding, 20),
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
                                        color: _isDarkMode ? Colors.white : Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Abdoulaye',
                                      style: TextStyle(
                                        color: _isDarkMode ? const Color(0xFFFF7900) : Colors.black87,
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
                                    _isSoldeVisible ? '0' : '*******',
                                    style: TextStyle(
                                      color: _isDarkMode ? const Color(0xFFFF7900) : Colors.black87,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: _isSoldeVisible ? 0 : 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'FCFA',
                                    style: TextStyle(
                                      color: _isDarkMode ? Colors.white : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Semantics(
                                    label: _isSoldeVisible ? 'Masquer le solde' : 'Afficher le solde',
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isSoldeVisible = !_isSoldeVisible;
                                        });
                                      },
                                      child: Icon(
                                        _isSoldeVisible ? Icons.visibility : Icons.visibility_off,
                                        color: _isDarkMode ? Colors.white : Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // QR Code avec accessibilité
                        Semantics(
                          label: 'Code QR personnel pour les paiements',
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isDarkMode ? Colors.white : Colors.black,
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
                  ],
                ),
              ),
            ),
          ),

          // Contenu principal
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section principale avec onglets
                Container(
                  margin: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: !_isDarkMode
                        ? [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      // Onglets Payer / Transférer avec accessibilité
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: Row(
                          children: [
                            Expanded(
                              child: Semantics(
                                label: 'Option de paiement',
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPayerSelected = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Radio<bool>(
                                        value: true,
                                        groupValue: _isPayerSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            _isPayerSelected = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFFFF7900),
                                      ),
                                      Text(
                                        'Payer',
                                        style: TextStyle(
                                          color: _isDarkMode ? Colors.white : Colors.black,
                                          fontSize: 16,
                                          fontWeight: _isPayerSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Semantics(
                                label: 'Option de transfert',
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPayerSelected = false;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Radio<bool>(
                                        value: false,
                                        groupValue: _isPayerSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            _isPayerSelected = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFFFF7900),
                                      ),
                                      Text(
                                        'Transférer',
                                        style: TextStyle(
                                          color: _isDarkMode ? Colors.white : Colors.black,
                                          fontSize: 16,
                                          fontWeight: !_isPayerSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFF7900),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.currency_exchange,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Champs de saisie et image scanner
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Champs de formulaire
                            Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _numeroController,
                                    style: TextStyle(
                                      color: _isDarkMode ? Colors.white : Colors.black,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: _isPayerSelected
                                          ? 'Saisir le numéro/code marchand'
                                          : 'Saisir le numéro',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: _isDarkMode
                                          ? const Color(0xFF2A2A2A)
                                          : Colors.grey[100],
                                      suffixIcon: Icon(
                                        Icons.person_outline,
                                        color: const Color(0xFFFF7900),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _montantController,
                                    style: TextStyle(
                                      color: _isDarkMode ? Colors.white : Colors.black,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Saisir le montant',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: _isDarkMode
                                          ? const Color(0xFF2A2A2A)
                                          : Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Image scanner à droite avec accessibilité
                            Semantics(
                              label: 'Bouton pour scanner un code QR',
                              child: GestureDetector(
                                onTap: () {
                                  // Logique de scan
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Scanner activé'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[300],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner,
                                        size: 40,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Cliquer et\nscanner',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bouton Valider avec états de chargement
                      Padding(
                        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleValidation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7900),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Semantics(
                              label: 'Valider la transaction',
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Valider',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Section Max it
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pour toute autre opération',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Semantics(
                          label: 'Accéder à Max it pour d\'autres opérations',
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7900),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Max it',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            title: Text(
                              'Accéder à Max it',
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: _isDarkMode ? Colors.white : Colors.black,
                              size: 16,
                            ),
                            onTap: () {
                              // Naviguer vers Max it
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section Historique
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
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
                      Semantics(
                        label: 'Rafraîchir l\'historique',
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: Color(0xFFFF7900),
                          ),
                          onPressed: () {
                            setState(() {
                              // Rafraîchir l'historique
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste des transactions
                _transactions.isEmpty
                    ? _buildEmptyHistory()
                    : _buildTransactionsList(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.cloud_outlined,
                size: 80,
                color: Colors.grey,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7900),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                right: 10,
                child: Icon(
                  Icons.search,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Vous n'avez pas encore de transaction Orange Money.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
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
        final transaction = _transactions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: !_isDarkMode
                ? [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction['icon'],
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            title: Text(
              transaction['type'],
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              transaction['subtitle'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction['amount'],
                  style: TextStyle(
                    color: transaction['isPositive']
                        ? Colors.green
                        : Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction['date'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[200],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
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
                    color: _isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '782917770',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.black87,
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
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            secondary: const Icon(Icons.brightness_6, color: Color(0xFFFF7900)),
            activeColor: const Color(0xFFFF7900),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.power_settings_new, color: Color(0xFFFF7900)),
            title: Text(
              'Se déconnecter',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
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
              style: TextStyle(
                color: const Color(0xFFFF7900),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
