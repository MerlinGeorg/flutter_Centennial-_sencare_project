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
  List<dynamic> filteredResidents = [];
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
         filteredResidents = List.from(residents);
        isLoading = false;
      });
      print("API data: $data");
      print("API id: ${data[0]['_id']}");
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

  void _filterResidents(String query) {
    setState(() {
      filteredResidents = residents
          .where((resident) =>
              resident['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
            // onChanged: (value) => {},
            onChanged: _filterResidents,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredResidents.isEmpty
                    ? const Center(child: Text('No residents found.'))
                : residents.isEmpty
                    ? Center(
                        child: Text('No residents found.'),
                      )
                    : ListView.builder(
                        itemCount: residents.length,
                        itemBuilder: (context, index) {
                          final resident = residents[index];

                          return ResidentListItem(
                              name: resident['name'],
                              onViewDetails: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.patientDetails,
                                    arguments: {'patientId': resident['_id']},
                                  ),
                              onEditDetails: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.editPatient,
                                    arguments: {'patientId': resident['_id']},
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
  final VoidCallback onViewDetails;
  final VoidCallback onEditDetails;
  final VoidCallback onDeleteResident;

  const ResidentListItem(
      {Key? key,
      required this.name,
      required this.onViewDetails,
      required this.onEditDetails,
      required this.onDeleteResident})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove_red_eye, color: Colors.green),
            onPressed: onViewDetails,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEditDetails,
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
