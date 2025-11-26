class LoginRequest {
  final String telephone;
  final String password;

  LoginRequest({
    required this.telephone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'password': password,
    };
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      telephone: json['telephone'] as String,
      password: json['password'] as String,
    );
  }
}
