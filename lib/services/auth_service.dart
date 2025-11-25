import '../models/user_model.dart';

/// Service de gestion de l'authentification et des sessions utilisateur
class AuthService {
  UserModel? _currentUser;
  String? _accessToken;
  String? _tokenType;

  /// Vérifie si un utilisateur est connecté
  bool get isAuthenticated => _currentUser != null && _accessToken != null;

  /// Récupère l'utilisateur actuellement connecté
  UserModel? get currentUser => _currentUser;

  /// Récupère le token d'accès
  String? get accessToken => _accessToken;

  /// Récupère le type de token
  String? get tokenType => _tokenType;

  /// Récupère le token d'autorisation complet (type + token)
  String? get authorizationHeader {
    if (_tokenType != null && _accessToken != null) {
      return '$_tokenType $_accessToken';
    }
    return null;
  }

  /// Connecte un utilisateur avec les informations de login OTP
  void login(LoginOtpResponse response) {
    _currentUser = response.user;
    _accessToken = response.accessToken;
    _tokenType = response.tokenType ?? 'Bearer';
  }

  /// Déconnecte l'utilisateur actuel
  void logout() {
    _currentUser = null;
    _accessToken = null;
    _tokenType = null;
  }

  /// Met à jour les informations de l'utilisateur
  void updateUser(UserModel user) {
    _currentUser = user;
  }
}
