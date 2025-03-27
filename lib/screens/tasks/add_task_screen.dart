import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Controllers for text fields
  final _taskNameController = TextEditingController();
  final _dutiesController = TextEditingController();
  
  // Static list of residents for dropdown
  final List<String> _residents = [
    'John Smith',
    'Culine Plat',
    'Ernad Tom'
  ];
  
  String? _selectedResident;

  @override
  void dispose() {
    _taskNameController.dispose();
    _dutiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task Name TextField
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Duties TextField
            TextField(
              controller: _dutiesController,
              decoration: InputDecoration(
                labelText: 'Duties',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Resident Assigned Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Resident Assigned',
                border: OutlineInputBorder(),
              ),
              value: _selectedResident,
              items: _residents.map((String resident) {
                return DropdownMenuItem<String>(
                  value: resident,
                  child: Text(resident),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedResident = newValue;
                });
              },
            ),
            SizedBox(height: 24),

            // Button Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit task
                      Navigator.pop(context);
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Cancel and go back
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}