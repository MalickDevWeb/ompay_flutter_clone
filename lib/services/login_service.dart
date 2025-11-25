import '../core/abstracts/i_user_service.dart';
import '../models/login_result.dart';
import 'auth_service.dart';

class LoginService {
  final IUserService userService;
  final AuthService authService;

  LoginService(this.userService, this.authService);

  /// Envoi OTP
  Future<LoginResult> sendOtp(String phone) async {
    final result = await userService.sendOtp(phone);
    return LoginResult(
      isSuccess: result.isSuccess,
      message: result.data?.message,
      error: result.error,
    );
  }

  /// Vérifie OTP et effectue login
  Future<LoginResult> loginWithOtp(String phone, String otpCode) async {
    final result = await userService.loginOtp(phone, otpCode);

    if (result.isSuccess && result.data != null) {
      authService.login(result.data!);
      return LoginResult(isSuccess: true, user: result.data!.user);
    } else {
      return LoginResult(isSuccess: false, error: result.error);
    }
  }
}
