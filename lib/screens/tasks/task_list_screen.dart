import 'package:flutter/material.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Static task data
  final List<Map<String, String>> _tasks = [
    {
      'taskName': 'Health Monitoring',
      'duties': 'Check BP and Temp',
      'residentAssigned': 'John Smith',
      'completed': 'false'
    },
    {
      'taskName': 'Feeding',
      'duties': 'Lunch',
      'residentAssigned': 'Culine Plat',
      'completed': 'false'
    },
    {
      'taskName': 'Medication',
      'duties': 'All Block1',
      'residentAssigned': 'Ernad Tom',
      'completed': 'false'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Task Name', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Duties', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Resident Assigned', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 1, 
                  child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Divider(),

          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(_tasks[index]['taskName'] ?? ''),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(_tasks[index]['duties'] ?? ''),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(_tasks[index]['residentAssigned'] ?? ''),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: _tasks[index]['completed'] == 'true',
                              onChanged: (bool? value) {
                                setState(() {
                                  _tasks[index]['completed'] = value.toString();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // TODO: Implement edit functionality
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Add New Task Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskScreen()),
                );
              },
              child: Text('Add New Task'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}