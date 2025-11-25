bool isValidPhoneNumber(String phone) {
  // Format sénégalais : commence par 70, 76, 77, 78, etc. suivi de 7 chiffres
  final phoneRegex = RegExp(r'^7[0678]\d{7}$');
  return phoneRegex.hasMatch(phone);
}
