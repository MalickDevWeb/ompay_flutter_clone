class PaginatedResponse<T> {
  final String status;
  final int page;
  final int limit;
  final int total;
  final List<T> data;

  PaginatedResponse({
    required this.status,
    required this.page,
    required this.limit,
    required this.total,
    required this.data,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse(
      status: json['status'] as String,
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    return {
      'status': status,
      'page': page,
      'limit': limit,
      'total': total,
      'data': data.map(toJson).toList(),
    };
  }
}
