import '../entities/compte_model.dart';

class CreateAccountResponse {
  final String status;
  final String message;
  final CompteModel data;

  CreateAccountResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateAccountResponse.fromJson(Map<String, dynamic> json) {
    return CreateAccountResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: CompteModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}
