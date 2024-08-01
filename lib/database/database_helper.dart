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
 Future<List<Task>> fetchTasksByDate(String date) async {
  final db = await database;
  try {
    // Log the query execution to help in debugging the invocation and input to the function
    developer.log('Fetching tasks for date: $date');

    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'dueDate = ?',
      whereArgs: [date],
    );
    
    // Log the result of the query to check what is retrieved from the database
    if (maps.isEmpty) {
      developer.log('No tasks found for date $date');
    } else {
      developer.log('Retrieved tasks: ${maps.length} for date $date');
      for (var map in maps) {
        developer.log('Task details: ID=${map['id']}, Title=${map['title']}, Note=${map['note']}, DueDate=${map['dueDate']}, Repeat=${map['repeat']}, Color=${map['color']}');
      }
    }
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  } catch (e) {
    developer.log('Error fetching tasks by date $date: $e');
    throw Exception('Failed to fetch tasks for date $date');
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
