import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'task.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE taskManage(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            dueTime TEXT,
            priority TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertTodo(Map<String, dynamic> todo) async {
    final db = await database;
    return await db.insert('taskManage', todo);
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await database;
    return await db.query('taskManage');
  }

  Future<int> updateTodo(int id, Map<String, dynamic> todo) async {
    final db = await database;
    return await db
        .update('taskManage', todo, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('taskManage', where: 'id = ?', whereArgs: [id]);
  }
}
