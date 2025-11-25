import 'daily_statistics.dart';

class DailyStatisticsResponse {
  final String status;
  final DailyStatistics data;

  DailyStatisticsResponse({
    required this.status,
    required this.data,
  });

  factory DailyStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return DailyStatisticsResponse(
      status: json['status']?.toString() ?? '',
      data: DailyStatistics.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}
