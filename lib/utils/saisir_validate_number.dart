import 'dart:io';
import '../core/validators/number_validator.dart';
import '../enums/messages.dart';

double? saisirValidateNumber(String prompt) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync()?.trim();

    if (input == null || input.isEmpty) {
      print("❌ Amount is required.");
      continue;
    }

    final amount = double.tryParse(input);
    if (amount == null || amount <= 0) {
      print("❌ Please enter a valid positive amount.");
      continue;
    }

    return amount;
  }
}

String promptAndValidatePhoneNumber() {
  while (true) {
    print(phoneNumberPrompt);
    stdout.write("📱 Numéro : ");
    String? phoneNumber = stdin.readLineSync()?.trim();

    if (phoneNumber == null || phoneNumber.isEmpty) {
      print("❌ Numéro de téléphone requis. Veuillez réessayer.\n");
      continue;
    }

    if (!isValidPhoneNumber(phoneNumber)) {
      print("❌ Format invalide. Le numéro doit commencer par 70, 76, 77 ou 78 suivi de 7 chiffres.\n");
      continue;
    }

    // Numéro valide, on le retourne
    return phoneNumber;

  }
}

String promptAndValidateOtpCode() {
  while (true) {
    print(otpCodePrompt);
    stdout.write("🔢 Code OTP : ");
    String? otpCode = stdin.readLineSync()?.trim();

    if (otpCode == null || otpCode.isEmpty) {
      print("❌ Code OTP requis. Veuillez réessayer.\n");
      continue;
    }

    // Validation du code OTP : doit être exactement 6 chiffres
    if (!RegExp(r'^\d{6}$').hasMatch(otpCode)) {
      print("❌ Le code OTP doit contenir exactement 6 chiffres.\n");
      continue;
    }

    return otpCode;
  }
}
