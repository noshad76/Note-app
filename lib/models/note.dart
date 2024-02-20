class Note {
  static String tableName = 'Notes';
  int? id;
  String? title;
  String? content;
  Note({this.id, this.title, this.content});

  Map<String, Object?> tojson() {
    return {
      DatabaseFields.id: id,
      DatabaseFields.title: title,
      DatabaseFields.content: content
    };
  }

  static Note fromjson(Map<String, Object?> json) {
    return Note(
        id: json[DatabaseFields.id] as int,
        title: json[DatabaseFields.title] as String,
        content: json[DatabaseFields.content] as String);
  }

  Future<Note> copy({required int? id, String? title, String? content}) async {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

class DatabaseFields {
  static String id = 'id';
  static String title = 'title';
  static String content = 'content';
  static List<String>? values = [id, title, content];
}
