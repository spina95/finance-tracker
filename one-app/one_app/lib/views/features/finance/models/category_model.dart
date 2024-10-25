class Category {
  int id;
  String? name;
  String? color;
  String? icon;
  String? flutterIcon;

  Category({
    required this.id,
    this.name,
    this.color,
    this.icon,
    this.flutterIcon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      icon: json['icon'],
      flutterIcon: json['icon_flutter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
    };
  }
}
