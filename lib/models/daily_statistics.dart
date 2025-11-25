class DailyStatistics {
  final int transfers;
  final int deposits;
  final int withdrawals;
  final int merchantPayments;

  DailyStatistics({
    required this.transfers,
    required this.deposits,
    required this.withdrawals,
    required this.merchantPayments,
  });

  factory DailyStatistics.fromJson(Map<String, dynamic> json) {
    return DailyStatistics(
      transfers: json['transfers'] as int? ?? 0,
      deposits: json['deposits'] as int? ?? 0,
      withdrawals: json['withdrawals'] as int? ?? 0,
      merchantPayments: json['merchant_payments'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transfers': transfers,
      'deposits': deposits,
      'withdrawals': withdrawals,
      'merchant_payments': merchantPayments,
    };
  }
}
