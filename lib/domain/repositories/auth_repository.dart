import 'package:test_flutter/domain/entities/user.dart';

abstract class AuthRepository {
  Future<String> getVerificationCode(String phoneNumber);
  Future<User?> authenticate(String phoneNumber, String code);
}
