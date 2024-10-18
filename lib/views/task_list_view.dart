import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import '../viewmodels/task_view_model.dart';
import 'add_task_view.dart';
import 'edit_task_view.dart';

class TaskListView extends StatefulWidget {
  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskViewModel>(context, listen: false).fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final incompleteTasks =
        taskViewModel.tasks.where((task) => !task.isCompleted).toList();
    final completedTasks =
        taskViewModel.tasks.where((task) => task.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskView()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incomplete Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (incompleteTasks.isEmpty)
              Center(child: Text('No incomplete tasks available.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: incompleteTasks.length,
                  itemBuilder: (context, index) {
                    final task = incompleteTasks[index];
                    return _buildTaskTile(taskViewModel, task);
                  },
                ),
              ),
            SizedBox(height: 20),
            Text(
              'Completed Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (completedTasks.isEmpty)
              Center(child: Text('No completed tasks available.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return _buildTaskTile(taskViewModel, task);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTile(TaskViewModel taskViewModel, Task task) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            margin: const EdgeInsets.only(right: 12.0),
            child: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                taskViewModel.updateTask(Task(
                  id: task.id,
                  title: task.title,
                  description: task.description,
                  startDate: task.startDate,
                  endDate: task.endDate,
                  isCompleted: value ?? false,
                ));
              },
            ),
          ),
      
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
         
                Center(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted
                          ? Colors.grey
                          : Colors.black, 
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none, 
                    ),
                  ),
                ),
                const SizedBox(height: 8),
          
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
           
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.blueGrey),
                    Text(
                      '  ${task.startDate.toLocal().toString().split(' ')[0]}  -  ${task.endDate.toLocal().toString().split(' ')[0]}',
                      style:
                          TextStyle(color: Colors.blueGrey[700], fontSize: 13),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Icon(Icons.calendar_today_outlined,
                //         size: 16, color: Colors.blueGrey),
                //     const SizedBox(width: 4),
                //     Text(
                //       'End: ${task.endDate.toLocal().toString().split(' ')[0]}',
                //       style:
                //           TextStyle(color: Colors.blueGrey[700], fontSize: 13),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
    
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blueGrey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskView(task: task),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
