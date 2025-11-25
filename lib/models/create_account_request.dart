class CreateAccountRequest {
  final String nomCompte;

  CreateAccountRequest({
    required this.nomCompte,
  });

  Map<String, dynamic> toJson() => {
    'nom_compte': nomCompte,
  };
}

class CreateAccountResponse {
  final String status;
  final String message;
  final dynamic data;

  CreateAccountResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CreateAccountResponse.fromJson(Map<String, dynamic> json) {
    return CreateAccountResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'],
    );
  }
}
