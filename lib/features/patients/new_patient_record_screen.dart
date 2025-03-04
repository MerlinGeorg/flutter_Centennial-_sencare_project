import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewPatientRecordScreen extends StatefulWidget {
  @override
  _NewPatientRecordScreenState createState() => _NewPatientRecordScreenState();
}

class _NewPatientRecordScreenState extends State<NewPatientRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Date controller
  final _dateController = TextEditingController();
  
  // Reading value controller
  final _readingController = TextEditingController();

  // Dropdown for type of data
  String _selectedDataType = 'Blood Pressure';
  final List<String> _dataTypes = [
    'Blood Pressure',
    'Heart Rate',
    'Temperature',
    'Blood Sugar',
    'Oxygen Saturation'
  ];

  @override
  void initState() {
    super.initState();
    // Set current date
    _dateController.text = _formatCurrentDate();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _readingController.dispose();
    super.dispose();
  }

  String _formatCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Patient Record'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date TextField
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Type of Data Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Type of Data',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDataType,
                items: _dataTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDataType = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Reading Value TextField
              TextFormField(
                controller: _readingController,
                decoration: InputDecoration(
                  labelText: 'Reading Value',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reading value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save patient record
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Patient Record Saved')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}