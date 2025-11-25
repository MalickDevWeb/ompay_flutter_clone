// Importer les packages nécessaires pour l'interface Flutter et les opérations asynchrones
import 'package:flutter/material.dart';
import 'package:test_flutter/ui/pages/client_page.dart';
import 'package:test_flutter/ui/pages/admin_page.dart';
import 'package:test_flutter/ui/pages/fournisseur_page.dart';
import 'package:test_flutter/ui/widgets/login/carrousel_images.dart';
import 'package:test_flutter/ui/widgets/login/formulaire_connexion.dart';
// import 'package:test_flutter/ui/widgets/login/wavy_clipper.dart';
import 'package:test_flutter/services/login_service.dart';
import 'package:test_flutter/core/validators/login_validator.dart';
// import 'package:provider/provider.dart';

// Widget principal de la page de connexion, stateful pour gérer le contenu dynamique
class LoginPage extends StatefulWidget {
  final LoginService loginService;

  const LoginPage({super.key, required this.loginService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Classe d'état pour LoginPage, gère l'état et le cycle de vie
class _LoginPageState extends State<LoginPage> {
  // Service pour la gestion de la connexion
  late final LoginService _loginService;

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
  // Messages d'erreur pour les champs
  String? _phoneError;
  String? _otpError;

  // Constantes pour les messages d'erreur
  static const String _otpSendErrorMessage = 'Erreur lors de l\'envoi de l\'OTP';

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

  void _navigateToFournisseur() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FournisseurPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loginService = widget.loginService;
    _phoneController.addListener(_clearPhoneError);
    _codeController.addListener(_clearOtpError);
  }

  void _clearPhoneError() {
    if (_phoneError != null) {
      setState(() {
        _phoneError = null;
      });
    }
  }

  void _clearOtpError() {
    if (_otpError != null) {
      setState(() {
        _otpError = null;
      });
    }
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
      await _handleOtpVerification();
    } else {
      await _handlePhoneSubmission();
    }
  }

  /// Handles OTP verification process with improved error handling and separation of concerns
  Future<void> _handleOtpVerification() async {
    // Input validation with trimmed text for better UX
    final otpCode = _codeController.text.trim();
    if (!LoginValidator.validateOtp(otpCode)) {
      _setOtpError(LoginValidator.getOtpErrorMessage());
      return;
    }

    // Clear previous errors and show loading state
    _clearErrorsAndStartLoading();

    try {
      final result = await _loginService.loginWithOtp(_phoneController.text.trim(), otpCode);

      if (!mounted) return;

      if (result.isSuccess && result.user != null) {
        // Navigate based on user type with null safety
        await _navigateBasedOnUserType(result.user!.type);
      } else {
        // Handle authentication failure with specific error message
        final errorMessage = result.error ?? 'OTP verification failed. Please try again.';
        _setOtpErrorAndStopLoading(errorMessage);
      }
    } on Exception catch (e) {
      // Handle network or service-specific exceptions
      if (mounted) {
        final errorMessage = _getErrorMessageFromException(e);
        _setOtpErrorAndStopLoading(errorMessage);
      }
    } catch (e) {
      // Handle unexpected errors with fallback message
      if (mounted) {
        _setOtpErrorAndStopLoading('An unexpected error occurred. Please try again.');
      }
    }
  }

  /// Navigates to appropriate page based on user type
  Future<void> _navigateBasedOnUserType(String? userType) async {
    if (userType == null) {
      _navigateToClient(); // Default fallback
      return;
    }

    switch (userType.toLowerCase()) {
      case 'admin':
        _navigateToAdmin();
        break;
      case 'fournisseur':
        _navigateToFournisseur();
        break;
      case 'client':
      case 'commerçant':
      default:
        _navigateToClient();
        break;
    }
  }

  /// Clears all errors and starts loading state
  void _clearErrorsAndStartLoading() {
    setState(() {
      _otpError = null;
      _phoneError = null;
      _isLoading = true;
    });
  }

  /// Sets OTP error and stops loading
  void _setOtpError(String message) {
    setState(() {
      _otpError = message;
    });
  }

  /// Sets OTP error and stops loading in one operation
  void _setOtpErrorAndStopLoading(String message) {
    setState(() {
      _otpError = message;
      _isLoading = false;
    });
  }

  /// Extracts user-friendly error message from exception
  String _getErrorMessageFromException(Exception e) {
    // Could be extended to handle specific exception types
    return 'Connection error: ${e.toString().split(':').last.trim()}';
  }

  // Gestion de la soumission du téléphone
  Future<void> _handlePhoneSubmission() async {
    // Validation du numéro de téléphone
    if (!LoginValidator.validatePhoneNumber(_phoneController.text)) {
      setState(() {
        _phoneError = LoginValidator.getPhoneErrorMessage();
      });
      return;
    }

    // Empêcher les soumissions multiples pendant le chargement
    if (_isLoading) return;

    // Réinitialiser les erreurs et activer le chargement
    setState(() {
      _phoneError = null;
      _isLoading = true;
    });

    try {
      // Utiliser le service pour envoyer l'OTP
      final result = await _loginService.sendOtp(_phoneController.text);

      if (!mounted) return;

      if (result.isSuccess) {
        // Succès : passer à l'étape du code
        setState(() {
          _isLoading = false;
          _isCodeStep = true;
        });
      } else {
        // Échec : afficher le message d'erreur du service
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar(result.error ?? _otpSendErrorMessage);
      }
    } catch (e) {
      // Gestion des erreurs inattendues
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('$_otpSendErrorMessage: $e');
      }
    }
  }

  // Méthode utilitaire pour afficher les erreurs
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
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
                phoneError: _phoneError,
                otpError: _otpError,
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
