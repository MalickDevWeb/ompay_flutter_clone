// Importer les packages nécessaires pour l'interface Flutter et les opérations asynchrones
import 'package:flutter/material.dart';
import 'package:test_flutter/ui/pages/client_page.dart';
import 'package:test_flutter/ui/pages/admin_page.dart';
import 'package:test_flutter/ui/widgets/login/carrousel_images.dart';
import 'package:test_flutter/ui/widgets/login/formulaire_connexion.dart';
// import 'package:test_flutter/ui/widgets/login/wavy_clipper.dart';
import 'package:test_flutter/services/communication/dio_client.dart';
import 'package:test_flutter/core/validators/login_validator.dart';

// Widget principal de la page de connexion, stateful pour gérer le contenu dynamique
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Classe d'état pour LoginPage, gère l'état et le cycle de vie
class _LoginPageState extends State<LoginPage> {
  // Contrôleur pour la saisie du numéro de téléphone
  final TextEditingController _phoneController = TextEditingController();
  // Contrôleur pour la saisie du code de vérification
  final TextEditingController _codeController = TextEditingController();
  // Code pays sélectionné pour la saisie du téléphone
  String selectedCountryCode = '+221';
  // Étape actuelle : false pour téléphone, true pour code
  bool _isCodeStep = false;
  // Indicateur de chargement pour l'envoi d'OTP
  bool _isLoading = false;

  // Méthode pour vérifier si les credentials correspondent à un admin
  // Amélioration: Extraire la logique de vérification admin pour meilleure maintenabilité
  bool _isAdminCredentials(String phone, String code) {
    // TODO: Remplacer par une vérification via service ou config
    return phone == '770000000' && code == '111111';
  }

  // Méthodes de navigation pour améliorer la lisibilité
  // Amélioration: Extraire la navigation pour séparer les préoccupations
  void _navigateToAdmin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminPage()),
    );
  }

  void _navigateToClient() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ClientPage()),
    );
  }

  // Nettoyer les ressources lorsque le widget est supprimé
  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  // Fonction appelée lors du changement de code pays
  // Amélioration: Gestion des cas où value est null pour éviter les erreurs
  void _onCountryCodeChanged(String? value) {
    if (value != null && value.isNotEmpty) {
      setState(() {
        selectedCountryCode = value;
      });
    }
  }

  // Fonction appelée lors de l'appui sur le bouton
  // Amélioration: Refactorisation pour meilleure lisibilité, utilisation de méthodes extraites, et vérification du contexte monté
  Future<void> _onButtonPressed() async {
    if (_isCodeStep) {
      _handleOtpVerification();
    } else {
      await _handlePhoneSubmission();
    }
  }

  // Gestion de la vérification OTP
  void _handleOtpVerification() {
    if (LoginValidator.validateOtp(_codeController.text)) {
      if (_isAdminCredentials(_phoneController.text, _codeController.text)) {
        _navigateToAdmin();
      } else {
        _navigateToClient();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LoginValidator.getOtpErrorMessage()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Gestion de la soumission du téléphone
  Future<void> _handlePhoneSubmission() async {
    if (LoginValidator.validatePhoneNumber(_phoneController.text)) {
      setState(() {
        _isLoading = true;
      });
      try {
        final dioClient = DioClient();
        await dioClient.post('/sendOTP', {'telephone': _phoneController.text});
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isCodeStep = true;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'envoi de l\'OTP: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LoginValidator.getPhoneErrorMessage()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Construire l'interface utilisateur pour la page de connexion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // Corps principal avec disposition verticale
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Section supérieure avec carrousel d'images
              const CarrouselImages(),
              // Barre grise centrale avec clip ondulé
              ClipPath(
                clipper: WavyClipper(),
                child: Container(
                  width: double.infinity,
                  height: 80,
                  color: const Color(0xFF1C1C1C), // Gris anthracite
                ),
              ),
              // Section inférieure avec formulaire de connexion
              FormulaireConnexion(
                phoneController: _phoneController,
                codeController: _codeController,
                isCodeStep: _isCodeStep,
                selectedCountryCode: selectedCountryCode,
                onCountryCodeChanged: _onCountryCodeChanged,
                onButtonPressed: _onButtonPressed,
              ),
            ],
          ),
          // Indicateur de chargement pendant l'envoi d'OTP
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 40);

    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 40);

    path.quadraticBezierTo(size.width * 0.75, 80, size.width, 40);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
