class PaymentType {
  int id;
  String? name;
  String? color;
  String? icon;
  String? flutterIcon;

  PaymentType({
    required this.id,
    this.name,
    this.color,
    this.icon,
    this.flutterIcon,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      icon: json['icon'],
      flutterIcon: json['flutter_icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'icon_flutter': flutterIcon,
    };
  }
}
