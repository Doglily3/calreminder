import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import '../models/task.dart';
import '../database/database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Task> get tasks => _tasks;

void fetchTasksByDate(String date) async {
  try {
    final taskMaps = await DatabaseHelper.instance.fetchTasksByDate(date);
    _tasks = taskMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
    notifyListeners();
  } catch (e) {
    // 这里可以处理错误，例如记录日志或更新 UI 状态
    developer.log('Error fetching tasks by date: $e');
  }
}



  void addTask(Task task) async {
    await _dbHelper.insertTask(task.toMap());
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) async {
    await _dbHelper.updateTask(task.toMap());
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(int taskId) async {
    await _dbHelper.deleteTask(taskId);
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
}
