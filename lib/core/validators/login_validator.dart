class LoginValidator {
  // Validation du numéro de téléphone sénégalais
  static bool validatePhoneNumber(String phone) {
    final RegExp phoneRegExp = RegExp(r'^[76-8]\d{8}$');
    return phoneRegExp.hasMatch(phone);
  }

  // Validation du code OTP
  static bool validateOtp(String otp) {
    final RegExp otpRegExp = RegExp(r'^\d{6}$');
    return otpRegExp.hasMatch(otp);
  }

  // Messages d'erreur
  static String getPhoneErrorMessage() {
    return 'Numéro de téléphone invalide. Doit être 9 chiffres commençant par 7, 6 ou 8.';
  }

  static String getOtpErrorMessage() {
    return 'Code OTP invalide. Doit être exactement 6 chiffres.';
  }
}
