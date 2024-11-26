class TotalPaymentType {
  int paymentTypeId;
  String paymentTypeName;
  String? paymentTypeColor;
  String? paymentTypeIcon;
  String? paymentTypeIconFlutter;
  double? totalAmount;

  TotalPaymentType({
    required this.paymentTypeId,
    required this.paymentTypeName,
    this.paymentTypeColor,
    this.paymentTypeIcon,
    this.paymentTypeIconFlutter,
    this.totalAmount,
  });

  factory TotalPaymentType.fromJson(Map<String, dynamic> json) {
    return TotalPaymentType(
      paymentTypeId: json['payment_type_id'],
      paymentTypeName: json["payment_type_name"],
      paymentTypeColor: json["payment_type_color"],
      paymentTypeIcon: json["payment_type_icon"],
      paymentTypeIconFlutter: json["payment_type_icon_flutter"],
      totalAmount: json["total_amount"]?.toDouble(),
    );
  }
}
