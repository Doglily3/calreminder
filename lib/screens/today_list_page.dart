import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/task_provider.dart'; // Ensure correct path
import 'add_task_page.dart';

class TodayListPage extends StatefulWidget {
  const TodayListPage({super.key});

  @override
  TodayListPageState createState() => TodayListPageState();
}

class TodayListPageState extends State<TodayListPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchTasksForSelectedDay();
  }

  void _fetchTasksForSelectedDay() {
    if (_selectedDay != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay!);
      Provider.of<TaskProvider>(context, listen: false).fetchTasksByDate(dateStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks; // Get tasks from Provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today List'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: const {CalendarFormat.week: 'Week'},
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _fetchTasksForSelectedDay();
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.note),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage(selectedDate: _selectedDay ?? DateTime.now())),
          );
          _fetchTasksForSelectedDay(); // Refresh tasks after adding a new one
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
