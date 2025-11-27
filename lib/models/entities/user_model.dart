// lib/models/user_model.dart
class UserModel {
  final String? id;
  final String? nom;
  final String? prenom;
  final String? telephone;
  final String? email;
  final String? type;
  final String? statut;
  final String? pin;
  final Map<String, dynamic>? links;

  // Compatibility fields
  String? get name {
    final first = prenom ?? '';
    final last = nom ?? '';
    final full = '$first $last'.trim();
    return full.isEmpty ? null : full;
  }

  UserModel({
    this.id,
    this.nom,
    this.prenom,
    this.telephone,
    this.email,
    this.type,
    this.statut,
    this.pin,
    this.links,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = UserModel(
      id: json['id']?.toString(),
      nom: json['nom']?.toString(),
      prenom: json['prenom']?.toString(),
      telephone: json['telephone']?.toString(),
      email: json['email']?.toString(),
      type: json['type']?.toString(),
      statut: json['statut']?.toString(),
      pin: json['pin']?.toString(),
      links: json['links'] as Map<String, dynamic>?,
    );
    print('👤 UserModel.fromJson - ID: ${user.id}, Raw ID: ${json['id']}');
    return user;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'email': email,
    'type': type,
    'statut': statut,
    'pin': pin,
    'links': links,
  };

  @override
  String toString() => 'UserModel(id: $id, nom: $nom, prenom: $prenom, telephone: $telephone, email: $email, type: $type, statut: $statut)';
}

// Modèle pour la réponse du statut API
class StatusModel {
  final String? status;

  StatusModel({this.status});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'status': status};

  @override
  String toString() => 'StatusModel(status: $status)';
}

// Modèle pour la réponse de l'envoi OTP
class SendOtpResponse {
  final String? status;
  final String? message;
  final bool? requiresOtp;
  final String? email;
  final String? phoneNumber;
  final bool? otpSent;

  SendOtpResponse({
    this.status,
    this.message,
    this.requiresOtp,
    this.email,
    this.phoneNumber,
    this.otpSent,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      requiresOtp: json['requires_otp'] as bool?,
      email: json['email']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      otpSent: json['otp_sent'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'requires_otp': requiresOtp,
    'email': email,
    'phone_number': phoneNumber,
    'otp_sent': otpSent,
  };

  @override
  String toString() => 'SendOtpResponse(status: $status, message: $message, requiresOtp: $requiresOtp, email: $email, phoneNumber: $phoneNumber, otpSent: $otpSent)';
}

// Modèle pour la réponse de login OTP
class LoginOtpResponse {
  final String? status;
  final String? message;
  final String? accessToken;
  final String? tokenType;
  final UserModel? user;

  LoginOtpResponse({
    this.status,
    this.message,
    this.accessToken,
    this.tokenType,
    this.user,
  });

  factory LoginOtpResponse.fromJson(Map<String, dynamic> json) {
    return LoginOtpResponse(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      accessToken: json['access_token']?.toString(),
      tokenType: json['token_type']?.toString(),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'access_token': accessToken,
    'token_type': tokenType,
    'user': user?.toJson(),
  };

  @override
  String toString() => 'LoginOtpResponse(status: $status, message: $message, accessToken: $accessToken, tokenType: $tokenType, user: $user)';
}
