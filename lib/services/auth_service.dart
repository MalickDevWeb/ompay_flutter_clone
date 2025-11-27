import '../models/entities/user_model.dart';
import '../core/services/secure_storage_service.dart';

/// Service de gestion de l'authentification et des sessions utilisateur
class AuthService {
  UserModel? _currentUser;
  String? _accessToken;
  String? _tokenType;

  /// Vérifie si un utilisateur est connecté
  Future<bool> get isAuthenticated async {
    // Check both in-memory and persistent storage
    if (_currentUser != null && _accessToken != null) {
      return true;
    }
    return await SecureStorageService.isAuthenticated();
  }

  /// Récupère l'utilisateur actuellement connecté
  UserModel? get currentUser => _currentUser;

  /// Récupère le token d'accès (synchrone pour compatibilité)
  String? get accessToken => _accessToken;

  /// Récupère le type de token (synchrone pour compatibilité)
  String? get tokenType => _tokenType;

  /// Récupère le token d'accès de manière asynchrone
  Future<String?> getAccessTokenAsync() async {
    if (_accessToken != null) {
      return _accessToken;
    }
    return await SecureStorageService.getAccessToken();
  }

  /// Récupère le type de token de manière asynchrone
  Future<String?> getTokenTypeAsync() async {
    if (_tokenType != null) {
      return _tokenType;
    }
    return await SecureStorageService.getTokenType();
  }

  /// Récupère le token d'autorisation complet (type + token)
  Future<String?> get authorizationHeader async {
    final tokenType = await getTokenTypeAsync();
    final accessToken = await getAccessTokenAsync();
    print('🔑 Token type: $tokenType, Access token: ${accessToken != null ? 'present' : 'null'}');

    if (tokenType != null && accessToken != null) {
      final header = '$tokenType $accessToken';
      print('🔑 Authorization header: $header');
      return header;
    }
    print('🔑 No authorization header available');
    return null;
  }

  /// Initialise le service en chargeant les données depuis le stockage sécurisé
  Future<void> initialize() async {
    final accessToken = await SecureStorageService.getAccessToken();
    final tokenType = await SecureStorageService.getTokenType();
    final userId = await SecureStorageService.getUserId();

    if (accessToken != null && tokenType != null && userId != null) {
      _accessToken = accessToken;
      _tokenType = tokenType;
      // Note: UserModel would need to be loaded separately if needed
      // For now, we assume user data is loaded on demand
    }
  }

  /// Connecte un utilisateur avec les informations de login OTP
  Future<void> login(LoginOtpResponse response) async {
    _currentUser = response.user;
    _accessToken = response.accessToken;
    _tokenType = response.tokenType ?? 'Bearer';

    print('🔐 AuthService.login - User ID: ${response.user?.id}, AccessToken present: ${response.accessToken != null}');

    // Store in secure storage - allow even if user ID is null for now
    if (response.accessToken != null) {
      await SecureStorageService.storeAuthTokens(
        accessToken: response.accessToken!,
        tokenType: _tokenType!,
        userId: response.user?.id?.toString() ?? 'unknown',
        userType: response.user?.type ?? 'client',
      );
      print('✅ Auth tokens stored successfully');
    } else {
      print('❌ Cannot store auth tokens: access token is null');
    }
  }

  /// Déconnecte l'utilisateur actuel
  Future<void> logout() async {
    _currentUser = null;
    _accessToken = null;
    _tokenType = null;

    // Clear secure storage
    await SecureStorageService.clearAuthData();
  }

  /// Met à jour les informations de l'utilisateur
  void updateUser(UserModel user) {
    _currentUser = user;
  }
}
