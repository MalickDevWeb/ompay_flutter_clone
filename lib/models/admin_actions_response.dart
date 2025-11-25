class AdminActionsResponse {
  final String status;
  final String message;
  final AdminActionsData data;

  AdminActionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AdminActionsResponse.fromJson(Map<String, dynamic> json) {
    return AdminActionsResponse(
      status: json['status'],
      message: json['message'],
      data: AdminActionsData.fromJson(json['data']),
    );
  }
}

class AdminActionsData {
  final int currentPage;
  final List<AdminAction> data;
  final int perPage;
  final int total;

  AdminActionsData({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.total,
  });

  factory AdminActionsData.fromJson(Map<String, dynamic> json) {
    return AdminActionsData(
      currentPage: json['current_page'],
      data: (json['data'] as List).map((item) => AdminAction.fromJson(item)).toList(),
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}

class AdminAction {
  final int id;
  final AdminActionUser admin;
  final String actionType;
  final AdminActionUser? targetUser;
  final Map<String, dynamic> details;
  final DateTime createdAt;

  AdminAction({
    required this.id,
    required this.admin,
    required this.actionType,
    this.targetUser,
    required this.details,
    required this.createdAt,
  });

  factory AdminAction.fromJson(Map<String, dynamic> json) {
    return AdminAction(
      id: json['id'],
      admin: AdminActionUser.fromJson(json['admin']),
      actionType: json['action_type'],
      targetUser: json['target_user'] != null ? AdminActionUser.fromJson(json['target_user']) : null,
      details: json['details'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class AdminActionUser {
  final String id;
  final String nom;
  final String prenom;
  final String? telephone;

  AdminActionUser({
    required this.id,
    required this.nom,
    required this.prenom,
    this.telephone,
  });

  factory AdminActionUser.fromJson(Map<String, dynamic> json) {
    return AdminActionUser(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
    );
  }
}
