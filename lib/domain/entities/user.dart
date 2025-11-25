class User {
  final String phoneNumber;
  final String userType; // 'client' or 'admin'

  User({required this.phoneNumber, required this.userType});

  User copyWith({String? phoneNumber, String? userType}) {
    return User(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
    );
  }
}
