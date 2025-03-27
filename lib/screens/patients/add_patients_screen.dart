import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sencare_project/services/api_service.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  String _healthStatus = 'Normal';
  DateTime? _admissionDate = DateTime.now().toLocal();

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _ageController.dispose();
    _roomNumberController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   try {
  //     print("control is here");
  //     final DateTime? picked = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(2000),
  //         lastDate: DateTime(2025));

  //     if (picked != null) {
  //       setState(() {
  //         _admissionDate = picked;
  //       });
  //     } else {
  //       _admissionDate = DateTime.timestamp();
  //     }
  //   } catch (e) {
  //     print("Error occurred while opening date picker: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Patient'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name TextField
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Age TextField
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Health Status Radio Buttons
              Text(
                'Health Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Radio(
                    value: 'Normal',
                    groupValue: _healthStatus,
                    onChanged: (value) {
                      setState(() {
                        _healthStatus = value.toString();
                      });
                    },
                  ),
                  Text('Normal'),
                  Radio(
                    value: 'Critical',
                    groupValue: _healthStatus,
                    onChanged: (value) {
                      setState(() {
                        _healthStatus = value.toString();
                      });
                    },
                  ),
                  Text('Critical'),
                ],
              ),
              SizedBox(height: 16),

              // Medical History TextField
              TextFormField(
                controller: _medicalHistoryController,
                decoration: InputDecoration(
                  labelText: 'Health Conditions',
                  hintText: 'Describe previous medical issues history',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Room Number TextField
              TextFormField(
                controller: _roomNumberController,
                decoration: InputDecoration(
                  labelText: 'Room Number',
                  hintText: 'Enter Room Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),

              //  Upload Photo
              OutlinedButton.icon(
                onPressed: () {
                  // Implement photo upload functionality
                },
                icon: Icon(Icons.upload_file),
                label: Text('Upload Photo'),
              ),
              SizedBox(height: 16),

              // Admission Date Picker
              // ListTile(
              //     leading: const Icon(Icons.calendar_today),
              //     title: Text(_admissionDate == null
              //         ? 'Select Admission date'
              //         : 'Admission Date: ${_admissionDate!.toLocal()}'),
              //     trailing: const Icon(Icons.keyboard_arrow_down),
              //     onTap: () {
              //       print("Opening date picker...");
              //       _selectDate(context);
              //     }),
              SizedBox(height: 16),
              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_admissionDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please select an admission date')),
                    );
                    return;
                  }
                  print("save clicked");

                  final patientData = {
                    'name': _nameController.text,
                    'age': int.parse(_ageController.text),
                    'health_status': _healthStatus,
                    'health_conditions': _medicalHistoryController.text,
                    'room_number': int.parse(_roomNumberController.text),
                    'admission_date': _admissionDate!.toIso8601String(),
                    'admission_number':
                        '${_nameController.text.substring(0, 3).toUpperCase()}${_ageController.text}'
                  };
                  print("post data: $patientData");
                  if (_formKey.currentState!.validate()) {
                    await apiService.post('/create', patientData);

                    // Save patient data
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('New Patient Added')),
                    );
                    Navigator.pop(context, true);
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
