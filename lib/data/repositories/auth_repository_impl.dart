import 'package:test_flutter/data/services/auth_service.dart';
import 'package:test_flutter/domain/entities/user.dart';
import 'package:test_flutter/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<String> getVerificationCode(String phoneNumber) async {
    return _authService.getVerificationCode(phoneNumber);
  }

  @override
  Future<User?> authenticate(String phoneNumber, String code) async {
    final expectedCode = _authService.getVerificationCode(phoneNumber);
    if (code == expectedCode) {
      final userType = _authService.getUserType(phoneNumber);
      return User(phoneNumber: phoneNumber, userType: userType);
    }
    return null;
  }
}
