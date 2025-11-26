class AdminUser {
  final String id;
  final String nom;
  final String prenom;
  final String? telephone;

  AdminUser({
    required this.id,
    required this.nom,
    required this.prenom,
    this.telephone,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: json['telephone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      if (telephone != null) 'telephone': telephone,
    };
  }
}

class ActionDetails {
  final String action;

  ActionDetails({
    required this.action,
  });

  factory ActionDetails.fromJson(Map<String, dynamic> json) {
    return ActionDetails(
      action: json['action'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
    };
  }
}

class AdminAction {
  final int id;
  final AdminUser admin;
  final String actionType;
  final AdminUser targetUser;
  final ActionDetails details;
  final DateTime createdAt;

  AdminAction({
    required this.id,
    required this.admin,
    required this.actionType,
    required this.targetUser,
    required this.details,
    required this.createdAt,
  });

  factory AdminAction.fromJson(Map<String, dynamic> json) {
    return AdminAction(
      id: json['id'] as int,
      admin: AdminUser.fromJson(json['admin'] as Map<String, dynamic>),
      actionType: json['action_type'] as String,
      targetUser: AdminUser.fromJson(json['target_user'] as Map<String, dynamic>),
      details: ActionDetails.fromJson(json['details'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin': admin.toJson(),
      'action_type': actionType,
      'target_user': targetUser.toJson(),
      'details': details.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
