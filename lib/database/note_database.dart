import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';

class NoteDatabase {
  NoteDatabase._init();
  static NoteDatabase instans = NoteDatabase._init();
  Database? _database;
  String dataBaseName = 'Notes.db';

  Future<Database?> get initializeDataBase async {
    if (_database != null) {
      return _database!;
    }
    return _database = await createDb();
  }

  Future<Database> createDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dataBaseName);
    return openDatabase(path, version: 1, onCreate: onCreateDb);
  }

  Future<void> onCreateDb(Database db, int ver) async {
    String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    String textType = 'TEXT NOT NULL';
    await db.execute('''
CREATE TABLE ${Note.tableName} (
  ${DatabaseFields.id} $idType ,
  ${DatabaseFields.title} $textType ,
  ${DatabaseFields.content} $textType 
)
''');
  }

  Future<Note> createnote(Note note) async {
    final db = await instans.initializeDataBase;
    int id = await db!.insert(Note.tableName, note.tojson());
    return note.copy(id: id);
  }

  Future<Note> readnote(int id) async {
    final db = await instans.initializeDataBase;
    List<Map<String, Object?>> map = await db!.query(Note.tableName,
        columns: DatabaseFields.values,
        where: '${DatabaseFields.id} = ?',
        whereArgs: [id]);
    return Note.fromjson(map.first);
  }

  Future<List<Note>?> readAllNotes() async {
    final db = await instans.initializeDataBase;
    List<Map<String, Object?>> map = await db!.query(Note.tableName);
    if (map.isNotEmpty) {
      return map.map((jsom) => Note.fromjson(jsom)).toList();
    } else {
      return null;
    }
  }

  Future<int> editNote(Note note) async {
    final db = await instans.initializeDataBase;
    int id = await db!.update(
      Note.tableName,
      note.tojson(),
      where: '${DatabaseFields.id} = ?',
      whereArgs: [note.id],
    );
    return id;
  }

  Future<int> deleteNote(int id) async {
    final db = await instans.initializeDataBase;
    int res = await db!.delete(Note.tableName,
        where: '${DatabaseFields.id} = ?', whereArgs: [id]);

    return res;
  }

  Future closeDb() async {
    final db = await instans.initializeDataBase;
    db!.close();
  }
}
