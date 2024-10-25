class TotalMonth {
  int month;
  double total;

  TotalMonth({
    required this.month,
    required this.total,
  });

  factory TotalMonth.fromJson(Map<String, dynamic> json) {
    return TotalMonth(
        month: json['month'],
        total: json["total_amount"] is int
            ? (json['total_amount'] as int).toDouble()
            : json['total_amount']);
  }
}
