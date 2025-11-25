import 'package:flutter/material.dart';
import 'package:test_flutter/data/repositories/auth_repository_impl.dart';
import 'package:test_flutter/data/services/auth_service.dart';
import 'package:test_flutter/domain/entities/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl(AuthService());

  User? _currentUser;
  bool _isCodeStep = false;
  String? _expectedCode;
  String? _userType;

  User? get currentUser => _currentUser;
  bool get isCodeStep => _isCodeStep;
  String? get expectedCode => _expectedCode;
  String? get userType => _userType;

  void startPhoneVerification(String phoneNumber) async {
    _expectedCode = await _authRepository.getVerificationCode(phoneNumber);
    if (phoneNumber == '771719013') {
      _userType = 'client';
    } else if (phoneNumber == '770000000') {
      _userType = 'admin';
    } else {
      _userType = 'client';
    }
    _isCodeStep = true;
    notifyListeners();
  }

  void authenticate(String code) async {
    if (_expectedCode == code) {
      _currentUser = User(phoneNumber: '', userType: _userType!); // Simplified
    }
    notifyListeners();
  }

  void reset() {
    _currentUser = null;
    _isCodeStep = false;
    _expectedCode = null;
    _userType = null;
    notifyListeners();
  }
}
