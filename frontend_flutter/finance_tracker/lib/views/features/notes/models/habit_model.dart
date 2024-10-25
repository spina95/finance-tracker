class Habit {
  int? id;
  String name;
  String icon;
  DateTime? createdAt;
  DateTime? updatedAt;

  Habit({
    this.id,
    required this.name,
    required this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['last_updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'text': icon};
  }
}
