import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_service.dart';
class TaskViewModel with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseService _databaseService = DatabaseService();

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await _databaseService.getTasks();
 
    _tasks.sort((a, b) => a.startDate.compareTo(b.startDate));
    notifyListeners();
  }

  Future<void> addTask(String title, String description, DateTime startDate, DateTime endDate) async {
    await _databaseService.insertTask(Task(
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
    ));
    fetchTasks();  
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task);
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    fetchTasks();
  }
}
