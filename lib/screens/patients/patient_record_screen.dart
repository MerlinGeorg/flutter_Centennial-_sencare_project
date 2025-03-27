import 'package:flutter/material.dart';
import 'package:sencare_project/services/navigation_service.dart';
import 'package:sencare_project/screens/patients/new_patient_record_screen.dart';

class PatientRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Record'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildRecordTable(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  NavigationService.instance.navigateTo('/newPatientRecord');
                },
                child: Text('Add New Patient Record'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordTable() {
    return Card(
      elevation: 4,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Date/Time')),
            DataColumn(label: Text('Type of Data')),
            DataColumn(label: Text('Reading')),
            DataColumn(label: Text('Normal Range')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('02/07/2020')),
              DataCell(Text('Blood Pressure')),
              DataCell(Text('90/70')),
              DataCell(Text('90-160 (systolic/diastolic)')),
            ]),
            DataRow(cells: [
              DataCell(Text('11/11/2024')),
              DataCell(Text('Heart Rate')),
              DataCell(Text('60-100 bpm')),
              DataCell(Text('60-100 bpm')),
            ]),
          ],
        ),
      ),
    );
  }
}