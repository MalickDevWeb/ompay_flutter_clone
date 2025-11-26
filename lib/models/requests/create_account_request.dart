class CreateAccountRequest {
  final int utilisateurId;
  final String type;
  final String? codeMarchand;

  CreateAccountRequest({
    required this.utilisateurId,
    required this.type,
    this.codeMarchand,
  });

  Map<String, dynamic> toJson() {
    return {
      'utilisateur_id': utilisateurId,
      'type': type,
      if (codeMarchand != null) 'code_marchand': codeMarchand,
    };
  }

  factory CreateAccountRequest.fromJson(Map<String, dynamic> json) {
    return CreateAccountRequest(
      utilisateurId: json['utilisateur_id'] as int,
      type: json['type'] as String,
      codeMarchand: json['code_marchand'] as String?,
    );
  }
}
