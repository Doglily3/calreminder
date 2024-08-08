import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      dueDate: DateTime.parse(data['dueDate']),  // 直接解析 yyyy-MM-dd 格式
      //reminder: data['reminder'],
      repeat: data['repeat'],
      color: Color(data['color']), // 从整数转换为 Color 对象
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'dueDate': DateFormat('yyyy-MM-dd').format(dueDate),  // 日期格式化为 yyyy-MM-dd
      //'reminder': reminder,
      'repeat': repeat,
      'color': color.value,  // 存储颜色值（整数）
    };
  }
}
