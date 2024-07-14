import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddTaskPage({super.key, required this.selectedDate});

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late DateTime _selectedDate;
  int _selectedReminder = 5;
  final List<int> _reminderOptions = [5, 10, 15, 20, 30];
  String _selectedRepeat = 'None';
  final List<String> _repeatOptions = ['None', 'Daily', 'Weekly', 'Monthly'];
  Color _selectedColor = Colors.blue;
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                  text: DateFormat.yMd().format(_selectedDate)),
              onTap: _pickDate,
            ),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Remind',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              controller: TextEditingController(
                  text: '$_selectedReminder minutes early'),
              onTap: () => _selectReminder(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Repeat',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.repeat),
              ),
              controller: TextEditingController(text: _selectedRepeat),
              onTap: () => _selectRepeat(),
            ),
            Wrap(
              children: _colorOptions
                  .map((color) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: color,
                            child: _selectedColor == color
                                ? const Icon(Icons.check, color: Colors.white)
                                : Container(),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // 设置按钮的背景颜色
                foregroundColor: Colors.white, // 设置按钮文字的颜色
              ),
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
      });
    }
  }

  void _selectReminder() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _reminderOptions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_reminderOptions[index]} minutes early'),
              onTap: () {
                setState(() {
                  _selectedReminder = _reminderOptions[index];
                  Navigator.pop(context);
                });
              },
            );
          },
        );
      },
    );
  }

  void _selectRepeat() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _repeatOptions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_repeatOptions[index]),
              onTap: () {
                setState(() {
                  _selectedRepeat = _repeatOptions[index];
                  Navigator.pop(context);
                });
              },
            );
          },
        );
      },
    );
  }

  void _saveTask() {
    // 构造任务描述字符串
    String taskDescription =
        'Task: ${_titleController.text}, Date: ${DateFormat.yMd().format(_selectedDate)}';
    // 返回任务描述并关闭页面
    Navigator.pop(context, taskDescription);
  }
}
