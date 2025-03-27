import 'package:flutter/material.dart';
import 'package:sencare_project/services/api_service.dart';
import 'package:sencare_project/widgets/AnimatedPressableButton.dart';
import 'patient_record_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String patientId; // Pass patient ID to fetch specific details

  const PatientDetailsScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? patientDetails;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    try {
      print("patientId: ${widget.patientId}");
      final data = await apiService.get('/fetch/${widget.patientId}');
      setState(() {
        patientDetails = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }


@override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Show a loading spinner while fetching data
  if (isLoading) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Patient Details'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            automaticallyImplyLeading: false, // Hides the back arrow
          ),
          body: SingleChildScrollView(
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.35,
                  decoration: BoxDecoration(
                      // color: Colors.blue,
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFB8500), // Orange at the top-left
                          Color(
                              0xFF083D77), // Blue towards the center and bottom-right
                        ],
                        stops: [0.1, 0.9], // Control the transition points
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          patientDetails!['name'],
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Text(
                      'Age: 60',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    _buildPatientInfoCard(),
                    SizedBox(height: 20),
                    AnimatedPressableButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientRecordScreen()),
                        );
                      },
                      text: 'Medical History',
                    )
                  ]),
                )
              ]))),
    );
  }
}

Widget _buildPatientInfoCard() {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Health Status', 'Normal'),
          _buildInfoRow('Admission Date', '04/28/2020'),
          _buildInfoRow('Admission Number', 'OKP200'),
          _buildInfoRow('Room Number', '305'),
          _buildInfoRow('Health Conditions', 'Obese, Paralyzed'),
        ],
      ),
    ),
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    ),
  );
}
