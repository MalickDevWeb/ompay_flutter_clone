class AdminAccountsResponse {
  final String status;
  final String message;
  final AdminAccountsData data;

  AdminAccountsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AdminAccountsResponse.fromJson(Map<String, dynamic> json) {
    return AdminAccountsResponse(
      status: json['status'],
      message: json['message'],
      data: AdminAccountsData.fromJson(json['data']),
    );
  }
}

class AdminAccountsData {
  final int currentPage;
  final List<AdminAccount> data;
  final int perPage;
  final int total;

  AdminAccountsData({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.total,
  });

  factory AdminAccountsData.fromJson(Map<String, dynamic> json) {
    return AdminAccountsData(
      currentPage: json['current_page'],
      data: (json['data'] as List).map((item) => AdminAccount.fromJson(item)).toList(),
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}

class AdminAccount {
  final String numeroCompte;
  final String titulaire;
  final double solde;
  final String statut;
  final String? codeMarchand;

  AdminAccount({
    required this.numeroCompte,
    required this.titulaire,
    required this.solde,
    required this.statut,
    this.codeMarchand,
  });

  factory AdminAccount.fromJson(Map<String, dynamic> json) {
    return AdminAccount(
      numeroCompte: json['numero_compte'],
      titulaire: json['titulaire'],
      solde: json['solde'].toDouble(),
      statut: json['statut'],
      codeMarchand: json['code_marchand'],
    );
  }
}
