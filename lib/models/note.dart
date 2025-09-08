class Note {
  final String id;
  String title;
  String body;
  List<String> tags;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.newNote() {
    final now = DateTime.now();
    return Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: "",
      body: "",
      tags: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  Note copyWith({
    String? title,
    String? body,
    List<String>? tags,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "tags": tags,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json["id"] as String,
    title: json["title"] as String? ?? "",
    body: json["body"] as String? ?? "",
    tags: (json["tags"] as List?)?.cast<String>() ?? <String>[],
    createdAt: DateTime.parse(json["createdAt"] as String),
    updatedAt: DateTime.parse(json["updatedAt"] as String),
  );
}
