import 'package:flutter/material.dart';

class Task {
  int? id;  // 主键
  String title;
  String note;
  DateTime dueDate;
  //int reminder;
  String repeat;
  Color color;

  Task({
    this.id,
    required this.title,
    required this.note,
    required this.dueDate,
    //required this.reminder,
    required this.repeat,
    required this.color,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      title: data['title'],
      note: data['note'],
      dueDate: data['dueDate'],
      repeat: data['repeat'],
      color: data['color'],
    );
  }
  
  // 将对象转换为Map对象，以便SQLite操作
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'dueDate': dueDate.toIso8601String(), // 日期转为ISO8601字符串
      //'reminder': reminder,
      'repeat': repeat,
      'color': color.value,  // 存储颜色值（整数）
    };
  }
}
