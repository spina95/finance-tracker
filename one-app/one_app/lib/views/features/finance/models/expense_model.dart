import 'package:one_app/views/features/finance/models/category_model.dart';
import 'package:one_app/views/features/finance/models/payment_type_model.dart';

class Expense {
  int? id;
  String? name;
  double? amount;
  DateTime? date;
  Category? category;
  PaymentType? paymentType;

  Expense({
    this.id,
    this.name,
    this.amount,
    this.date,
    this.category,
    this.paymentType,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      date: json['date'] == null ? null : DateTime.parse(json['date']),
      category: json['category_id'] != null
          ? Category.fromJson(json['category_id'])
          : null,
      paymentType: json['paymentType_id'] != null
          ? PaymentType.fromJson(json['paymentType_id'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date?.toIso8601String(),
    };
  }
}
