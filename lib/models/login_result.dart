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
}
