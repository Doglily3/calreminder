import 'package:intl/date_time_patterns.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;
import '../models/task.dart'; // for logging

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const sql = '''
CREATE TABLE tasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  note TEXT,
  dueDate TEXT,
  repeat TEXT,
  color INTEGER
);
''';
    await db.execute(sql);
    developer.log('Database created and Notes table has been initialized');
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    try {
      int id = await db.insert('tasks', task,
          conflictAlgorithm: ConflictAlgorithm.replace);
      developer.log('Inserted task with ID: $id $task');
      return id;
    } catch (e) {
      developer.log('Error inserting task: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> tasks = await db.query('tasks');
      developer.log('Fetched tasks: $tasks');
      return tasks;
    } catch (e) {
      developer.log('Failed to fetch tasks: $e');
      rethrow;
    }
  }

  // Add this method in your DatabaseHelper to fetch tasks by date
// 修改 DatabaseHelper 中的 fetchTasksByDate 方法，使其返回 List<Map<String, dynamic>>
Future<List<Map<String, dynamic>>> fetchTasksByDate(String date) async {
  final db = await database;
  try {
    developer.log('Fetching tasks for date: $date');
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'dueDate = ?',
      whereArgs: [date],
    );
    developer.log('Fetched tasks: $maps');
    return maps;  // 直接返回数据库查询结果
  } catch (e) {
    developer.log('Error fetching tasks by date $date: $e');
    rethrow;
  }
}



  Future<int> updateTask(Map<String, dynamic> task) async {
    final db = await database;
    int id = task['id'];
    try {
      int result =
          await db.update('tasks', task, where: 'id = ?', whereArgs: [id]);
      developer.log('Updated task with ID: $id');
      return result;
    } catch (e) {
      developer.log('Failed to update task: $e');
      rethrow;
    }
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    try {
      int result = await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      developer.log('Deleted task with ID: $id');
      return result;
    } catch (e) {
      developer.log('Failed to delete task: $e');
      rethrow;
    }
  }

  Future close() async {
    final db = await database;
    db.close();
    developer.log('Database connection closed');
  }
}
