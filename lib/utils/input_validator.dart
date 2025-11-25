/// Input validation utilities for user inputs
class InputValidator {
  static String? validatePhoneNumber(String phone) {
    final regex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!regex.hasMatch(phone)) {
      return 'Format de numéro de téléphone invalide';
    }
    return null;
  }

  static String? validateOtp(String otp) {
    if (otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
      return 'L\'OTP doit contenir 6 chiffres';
    }
    return null;
  }

  static String? validateAccountName(String name) {
    if (name.length < 3) return 'Nom de compte trop court';
    if (name.length > 50) return 'Nom de compte trop long';
    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(name)) {
      return 'Nom de compte contient des caractères invalides';
    }
    return null;
  }

  static String? validateAmount(double amount) {
    if (amount <= 0) return 'Le montant doit être positif';
    if (amount > 1000000) return 'Montant trop élevé';
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) return 'Le nom ne peut pas être vide';
    if (name.length < 2) return 'Nom trop court';
    if (name.length > 50) return 'Nom trop long';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Le nom contient des caractères invalides';
    }
    return null;
  }

  static String? validateEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(email)) {
      return 'Format d\'email invalide';
    }
    return null;
  }
}
