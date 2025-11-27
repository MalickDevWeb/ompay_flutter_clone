// Importer les packages nécessaires pour l'interface Flutter et les opérations asynchrones
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_flutter/ui/widgets/login/carrousel_images.dart';
import 'package:test_flutter/ui/widgets/login/formulaire_connexion.dart';
import 'package:test_flutter/services/login_service.dart';
import 'package:test_flutter/core/validators/login_validator.dart';
import 'package:test_flutter/core/services/secure_storage_service.dart';

// Widget principal de la page de connexion, stateful pour gérer le contenu dynamique
class LoginPage extends StatefulWidget {
  final LoginService loginService;

  const LoginPage({super.key, required this.loginService});

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
  // Messages d'erreur pour les champs
  String? _phoneError;
  String? _otpError;



  // Méthodes de navigation pour améliorer la lisibilité
  // Amélioration: Extraire la navigation pour séparer les préoccupations
  void _navigateToRoute(String route) {
    context.go(route);
  }

  @override
  void initState() {
    super.initState();
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

  /// Handles OTP verification process with real API
  Future<void> _handleOtpVerification() async {
    // Input validation with trimmed text for better UX
    final phone = _phoneController.text.trim();
    final otpCode = _codeController.text.trim();

    if (!LoginValidator.validateOtp(otpCode)) {
      _setOtpError(LoginValidator.getOtpErrorMessage());
      return;
    }

    // Clear previous errors and show loading state
    _clearErrorsAndStartLoading();

    try {

      final result = await widget.loginService.loginWithOtp(phone, otpCode);

      if (!mounted) return;

      print('🔍 Login result: isSuccess=${result.isSuccess}, user=${result.user}, redirectRoute=${result.redirectRoute}');
      if (result.user != null) {
        print('👤 User details: id=${result.user!.id}, type=${result.user!.type}, nom=${result.user!.nom}');
      }

      if (result.isSuccess && result.user != null) {
        print('✅ Login successful, checking user type: ${result.user!.type}');
        await _navigateBasedOnUserType(result.user!.type);
      } else {
        print('❌ Login failed: ${result.error}');
        _setOtpErrorAndStopLoading(result.error ?? 'Code OTP invalide. Veuillez réessayer.');
      }
    } catch (e) {
      if (!mounted) return;
      print('❌ Login error: $e');
      _setOtpErrorAndStopLoading('Erreur de connexion. Veuillez réessayer.');
    }
  }

  /// Navigates to appropriate page based on user type
  Future<void> _navigateBasedOnUserType(String? userType) async {
    // Log user type for debugging
    print('🔄 User type received: $userType');

    String route;
    if (userType == null || userType.isEmpty) {
      print('⚠️ User type is null or empty, checking secure storage as fallback');

      // Fallback: check user type from secure storage
      final storedUserType = await SecureStorageService.getUserType();
      print('🔄 Fallback user type from storage: $storedUserType');

      if (storedUserType != null && storedUserType.isNotEmpty) {
        userType = storedUserType;
      } else {
        print('⚠️ No user type found in storage, defaulting to client');
        route = '/client'; // Default fallback
        print('🚀 Navigating to default route: $route');
        _navigateToRoute(route);
        return;
      }
    }

    final normalizedType = userType!.toLowerCase().trim();
    print('🔄 Normalized user type: $normalizedType');

    switch (normalizedType) {
      case 'admin':
      case 'administrator':
      case 'superuser':
        print('👑 Admin user detected, redirecting to admin page');
        route = '/admin';
        break;
      case 'fournisseur':
      case 'provider':
      case 'supplier':
        print('🏭 Fournisseur user detected, redirecting to fournisseur page');
        route = '/fournisseur';
        break;
      case 'client':
      case 'commerçant':
      case 'merchant':
      case 'customer':
      case 'user':
        print('👤 Client user detected, redirecting to client page');
        route = '/client';
        break;
      default:
        print('❓ Unknown user type "$normalizedType", defaulting to client page');
        route = '/client';
        break;
    }

    print('🚀 Navigating to route: $route');
    _navigateToRoute(route);
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
      // Call the real send OTP service
      final result = await widget.loginService.sendOtp(_phoneController.text.trim());

      if (!mounted) return;

      if (result.isSuccess) {
        print('✅ OTP sent successfully');
        // Succès : passer à l'étape du code
        setState(() {
          _isLoading = false;
          _isCodeStep = true;
        });
      } else {
        print('❌ Failed to send OTP: ${result.error}');
        setState(() {
          _phoneError = result.error ?? 'Erreur lors de l\'envoi de l\'OTP';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      print('❌ Send OTP error: $e');
      setState(() {
        _phoneError = 'Erreur de connexion. Veuillez réessayer.';
        _isLoading = false;
      });
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
