import 'package:flutter/material.dart';
import 'package:sencare_project/config/routes.dart';
import 'package:sencare_project/services/api_service.dart';
import 'package:sencare_project/services/navigation_service.dart';
import 'package:sencare_project/screens/patients/add_patients_screen.dart';
import 'package:sencare_project/screens/patients/edit_patients_screen.dart';
import 'patient_details_screen.dart';

class ResidentListScreen extends StatefulWidget {
  const ResidentListScreen({Key? key}) : super(key: key);

  @override
  _ResidentListScreenState createState() => _ResidentListScreenState();
}

class _ResidentListScreenState extends State<ResidentListScreen> {
  TextEditingController _searchController = TextEditingController();

  final apiService = ApiService();

  List<dynamic> residents = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    print("it should be here");
    super.initState();
    fetchResidents();
  }

  Future<void> fetchResidents() async {
    setState(() {
      print("it's here");
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await apiService.get('/fetch');
      setState(() {
        residents = data;
        isLoading = false;
      });
      print("API data: $data");
      print("API id: ${data[0]['_id']}");
      print("API id: ${data[1]['_id']}");
      print("API id: ${data[2]['_id']}");
     
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deleteResident(String id) async {
    try {
      await apiService.delete('/delete/$id');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resident deleted successfully')),
      );
      fetchResidents(); // Refresh the list after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting resident: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resident List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          SearchBar(
            controller: _searchController,
            onChanged: (value) => {},
          ),
          Expanded(
            // child: ListView(
            //   children: [
            //     ResidentListItem(
            //       name: 'Dal Fig',
            //       age: 60,
            //     ),
            //   ],
            // ),
            child: ListView.builder(
                itemCount: residents.length,
                itemBuilder: (context, index) {
                  final resident = residents[index];
                  //  print("Resident Keys: $resident");
                  // print("patientId: ${resident['_id']}");
                  
                  return ResidentListItem(
                      name: resident['name'],
                      age: resident['age'],
                     //  id: resident['_id'],
                      onViewDetails: () => Navigator.pushNamed(
                          context,
                          // MaterialPageRoute(
                          //     builder: (context) => PatientDetailsScreen(patientId: resident['_id']))
                           AppRoutes.patientDetails,
                          arguments: {'patientId': resident['_id']},
                        ),
                      onEditDetails: () =>
                          // NavigationService.instance.navigateTo('/editPatient/${resident['_id']}'),
                          Navigator.pushNamed(
  context,
  AppRoutes.editPatient,
  arguments: {
    'patientId': resident['_id']
  },
),
                      onDeleteResident: () async =>
                          deleteResident(resident['_id']));
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPatientScreen()),
                );
                if (result == true) {
                  fetchResidents();
                }
              },
              child: Text('Add Resident'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResidentListItem extends StatelessWidget {
  final String name;
  final int age;
 // final String id;
  final VoidCallback onViewDetails;
  final VoidCallback onEditDetails;
  final VoidCallback onDeleteResident;

  const ResidentListItem(
      {Key? key,
      required this.name,
      required this.age,
    //  required this.id,
      required this.onViewDetails,
      required this.onEditDetails,
      required this.onDeleteResident})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('Age: $age'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove_red_eye, color: Colors.green),
            onPressed: onViewDetails,
          ),
       //  Text("patientId: $id"),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEditDetails
              // NavigationService.instance.navigateTo('/editPatient', arguments: {
              //   'name': 'Dal Fig',
              //   'age': '60',
              //   'healthStatus': 'Normal',
              //   'medicalHistory': 'Obese, Paralyzed',
              //   'roomNumber': '305',
              // });
            ,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDeleteResident,
          ),
        ],
      ),
    );
  }
}
