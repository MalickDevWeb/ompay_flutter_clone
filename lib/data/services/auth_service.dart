class AuthService {
  String getVerificationCode(String phoneNumber) {
    if (phoneNumber == '771719013') {
      return '123456';
    } else if (phoneNumber == '770000000') {
      return '654321';
    } else {
      return '000000';
    }
  }

  String getUserType(String phoneNumber) {
    if (phoneNumber == '771719013') {
      return 'client';
    } else if (phoneNumber == '770000000') {
      return 'admin';
    } else {
      return 'client';
    }
  }
}
