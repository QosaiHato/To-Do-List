import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import '../models/task.dart';

class EditTaskView extends StatefulWidget {
  final Task task;

  EditTaskView({required this.task});

  @override
  _EditTaskViewState createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _startDate = widget.task.startDate;
    _endDate = widget.task.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
        
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 20),
         
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
         
            Row(
              children: [
                Text("Start Date: "),
                TextButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                      });
                    }
                  },
                  child: Text(
                    _startDate == null
                        ? 'Pick Start Date'
                        : _startDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
              ],
            ),
        
            Row(
              children: [
                Text("End Date: "),
                TextButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                  child: Text(
                    _endDate == null
                        ? 'Pick End Date'
                        : _endDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
    
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _startDate != null &&
                    _endDate != null) {
  
                  Provider.of<TaskViewModel>(context, listen: false).updateTask(
                    Task(
                      id: widget.task.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      startDate: _startDate!,
                      endDate: _endDate!,
                      isCompleted: widget.task.isCompleted,
                    ),
                  );
                  Navigator.pop(context); 
                }
              },
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
