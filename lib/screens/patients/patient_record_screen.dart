import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sencare_project/config/routes.dart';
import 'package:sencare_project/services/api_service.dart';
import 'package:sencare_project/services/navigation_service.dart';
import 'package:sencare_project/screens/patients/new_patient_record_screen.dart';

  
  final apiServiceProvider = Provider((ref) => ApiService());

final patientRecordsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, id) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.fetchMedicalTests('/fetch/$id/clinical-data');
});


class PatientRecordScreen extends ConsumerWidget {
  final String patientId;

  PatientRecordScreen({required this.patientId});



bool isReadingOutOfRange(Map<String, dynamic> record) {
  final type = record['type_of_data'] ?? '';
  final reading = record['reading'] ?? '';
  final normalRange = record['normal_range'] ?? '';

  // Blood Pressure: "120/80", normal: "90-120/60-80"
  if (type == 'Blood Pressure') {
    final parts = reading.split('/');
    final normalParts = normalRange.split('/');
    if (parts.length == 2 && normalParts.length == 2) {
      final sys = int.tryParse(parts[0]);
      final dia = int.tryParse(parts[1]);
      final sysRange = normalParts[0].split('-').map((e) => int.tryParse(e)).toList();
      final diaRange = normalParts[1].split('-').map((e) => int.tryParse(e)).toList();
      if (sys != null && dia != null && sysRange.length == 2 && diaRange.length == 2) {
        if (sys < sysRange[0]! || sys > sysRange[1]! || dia < diaRange[0]! || dia > diaRange[1]!) {
          return true;
        }
      }
    }
  }

  // Heart Rate, Temperature, Blood Sugar, Oxygen Saturation: single value
  else if (['Heart Rate', 'Temperature', 'Blood Sugar', 'Oxygen Saturation'].contains(type)) {
    final value = double.tryParse(reading);
    final rangeParts = normalRange.split('-').map((e) => double.tryParse(e)).toList();
    if (value != null && rangeParts.length == 2 && rangeParts[0] != null && rangeParts[1] != null) {
      if (value < rangeParts[0]! || value > rangeParts[1]!) {
        return true;
      }
    }
  }

  // Default: not out of range
  return false;
}


  @override
  Widget build(BuildContext context, WidgetRef ref){
   final patientRecordsAsyncValue = ref.watch(patientRecordsProvider(patientId));

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
       body: patientRecordsAsyncValue.when(
        
        data: (records) {
  print('Fetched clinical data:');
  for (var record in records) {
    print(record);
  }
        
        return Column(
         

          children: [
            Expanded(child: _buildRecordTable(records)),
            ElevatedButton(
                onPressed: () async {
                 // NavigationService.instance.navigateTo('/newPatientRecord');
                  //  Navigator.pushNamed(
                  //         context,
                  //         AppRoutes.newPatientRecord,
                  //         arguments: {'patientId': patientId},
                  //       );
                  final result = await Navigator.pushNamed(
  context,
  AppRoutes.newPatientRecord,
  arguments: {'patientId': patientId},
);

if (result == true) {
  // Call fetch method to refresh the list
  ref.refresh(patientRecordsProvider(patientId));
}
                },
                child: Text('Add New Patient Record'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
     
    );
  }

final Map<String, String> _normalRanges = {
  'Blood Pressure': '90-120/60-80',
  'Heart Rate': '60-100',
  'Temperature': '97-99',
  'Blood Sugar': '70-140',
  'Oxygen Saturation': '95-100',
};
  Widget _buildRecordTable(List<Map<String, dynamic>> records) {
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
            DataColumn(label: Text('Unit')),
          ],
          rows: records.map((record) {
  final type = record['type_of_data'] ?? '';
  final outOfRange = isReadingOutOfRange({
    ...record,
    'normal_range': _normalRanges[type] ?? '',
  });
  return DataRow(
    color: outOfRange
        ? MaterialStateProperty.all(Colors.orange.withOpacity(0.3))
        : null,
    cells: [
      DataCell(Text(record['date_time'] ?.toString() ?? '')),
      DataCell(Text(type)),
      DataCell(Text(record['reading'] ?.toString() ?? '')),
      DataCell(Text(_normalRanges[type] ?.toString() ?? '')), // Use local normal range
      DataCell(Text(record['unit'] ?.toString() ?? '')),
    ],
  );
}).toList(),

         
        ),
      ),
    );
  }
}