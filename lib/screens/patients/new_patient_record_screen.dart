import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sencare_project/services/api_service.dart';

class NewPatientRecordScreen extends StatefulWidget {

  final String patientId;
  const NewPatientRecordScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _NewPatientRecordScreenState createState() => _NewPatientRecordScreenState();
}

class _NewPatientRecordScreenState extends State<NewPatientRecordScreen> {


  final apiService = ApiService();
   //  final patientRecordsAsyncValue = apiService.fetchMedicalTests('/create/:id/clinical-data');
  final _formKey = GlobalKey<FormState>();
  
  // Date controller
  final _dateController = TextEditingController();
  
  // Reading value controller
  final _readingController = TextEditingController();
  
  // Controllers for normal range and unit
  final _normalRangeController = TextEditingController();
  final _unitController = TextEditingController();

  // Dropdown for type of data
  String _selectedDataType = 'Blood Pressure';
  final List<String> _dataTypes = [
    'Blood Pressure',
    'Heart Rate',
    'Temperature',
    'Blood Sugar',
    'Oxygen Saturation'
  ];

   // Normal range and unit map
  final Map<String, Map<String, String>> _testMeta = {
    'Blood Pressure': {
      'normal_range': '90-120/60-80',
      'unit': 'mmHg',
    },
    'Heart Rate': {
      'normal_range': '60-100',
      'unit': 'bpm',
    },
    'Temperature': {
      'normal_range': '97-99',
      'unit': '°F',
    },
    'Blood Sugar': {
      'normal_range': '70-140',
      'unit': 'mg/dL',
    },
    'Oxygen Saturation': {
      'normal_range': '95-100',
      'unit': '%',
    },
  };

  @override
  void initState() {
    super.initState();
    // Set current date
    _dateController.text = _formatCurrentDate();
      _updateNormalRangeAndUnit(_selectedDataType);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _readingController.dispose();
    _normalRangeController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  // String _formatCurrentDate() {
  //   DateTime now = DateTime.now();
  //   return '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  // }
  String _formatCurrentDate() {
  DateTime now = DateTime.now();
  return now.toIso8601String();
//  return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
}


   void _updateNormalRangeAndUnit(String dataType) {
    _normalRangeController.text = _testMeta[dataType]?['normal_range'] ?? '';
    _unitController.text = _testMeta[dataType]?['unit'] ?? '';
  }


    // ------------- POST DATA FUNCTION -------------
  Future<void> _saveRecord() async {
    print("TOP LEVEL PRINT");
    if (!_formKey.currentState!.validate()) {
    print('❌ Validation failed');
    return;
  }
    else {
      final recordData = {
        'clinical_data': [{
'date_time': _dateController.text,
        'type_of_data': _selectedDataType,
        'reading': _readingController.text,
      //  'normal_range': _normalRangeController.text,
        'unit': _unitController.text,
        }

        ]
        
      };
      debugPrint("object: $recordData");
print("object: $recordData");
      try {
        // Adjust the route as needed for your backend
       final response = await apiService.addNewMedicalTest(
      '/create/${widget.patientId}/clinical-data',
      recordData,
    );

    // Check for error message in the response body
    if (response is Map && response.containsKey('message')) {
      // Backend sent a message, treat as error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save record: ${response['message']}')),
      );
      return;
    }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Patient Record Saved')),
          );
          Navigator.pop(context, true); // Return true to refresh parent if needed
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save record: $e')),
        );
      }
    }
  }
  // ----------------------------------------------


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
                    _updateNormalRangeAndUnit(newValue);
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

               // Normal Range (non-editable)
                TextFormField(
                  controller: _normalRangeController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Normal Range',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 16),

                // Unit (non-editable)
                 TextFormField(
                  controller: _unitController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _saveRecord,
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
