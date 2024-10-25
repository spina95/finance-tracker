class Note {
  int? id;
  String title;
  String text;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  Note({
    this.id,
    required this.title,
    required this.text,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['last_updated_at']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'text': text, 'status': status};
  }
}
