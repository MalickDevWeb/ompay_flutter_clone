import 'user_model.dart';

class LoginResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;
  final String? message;

  LoginResult({
    required this.isSuccess,
    this.user,
    this.error,
    this.message,
  });

  /// Get the appropriate route based on user type
  String? get redirectRoute {
    if (!isSuccess || user == null) {
      print('🔄 Redirect route: null (not success or no user)');
      return null;
    }

    final userType = user!.type?.toLowerCase();
    print('🔄 Calculating redirect route for user type: $userType (raw: ${user!.type})');
    print('🔄 User object: ${user!.toString()}');

    switch (userType) {
      case 'client':
        print('🔄 Redirect route: /client');
        return '/client';
      case 'admin':
        print('🔄 Redirect route: /admin');
        return '/admin';
      case 'fournisseur':
        print('🔄 Redirect route: /fournisseur');
        return '/fournisseur';
      default:
        print('🔄 Redirect route: /client (default - type was: $userType)');
        return '/client'; // Default fallback
    }
  }
}
