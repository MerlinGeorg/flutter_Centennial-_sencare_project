import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sencare_project/services/api_service.dart';

class EditPatientScreen extends StatefulWidget {
  // Patient data to be edited
  final String patientId; 
  // final String name;
  // final String age;
  // final String healthStatus;
  // final String medicalHistory;
  // final String roomNumber;

  const EditPatientScreen({
    Key? key,
    required this.patientId,
    // required this.age,
    // required this.healthStatus,
    // required this.medicalHistory,
    // required this.roomNumber,
  }) : super(key: key);

  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {

  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? patientDetails;
   bool isLoading = true;
  String errorMessage = '';
  
  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _roomNumberController;
  late TextEditingController _medicalHistoryController;

  late String _healthStatus;

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  
  }

Future<void> fetchPatientDetails() async {
    try {
      final data = await apiService.get('/fetch/${widget.patientId}');
      setState(() {
        patientDetails = data;
        isLoading = false;

         // Initialize controllers with fetched data
        _nameController = TextEditingController(text: patientDetails!['name']);
        _ageController = TextEditingController(text: patientDetails!['age'].toString());
        _roomNumberController = TextEditingController(text: patientDetails!['room_number'].toString());
        _medicalHistoryController = TextEditingController(text: patientDetails!['health_conditions']);
        _healthStatus = patientDetails!['health_status'];
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }


  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _ageController.dispose();
    _roomNumberController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Patient')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Patient')),
        body: Center(child: Text('Error: $errorMessage')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Patient'),
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

              // Upload Photo
              OutlinedButton.icon(
                onPressed: () {
                  // Implement photo upload functionality
                },
                icon: Icon(Icons.upload_file),
                label: Text('Update Photo'),
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save edited patient data
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Patient Information Updated')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Update'),
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