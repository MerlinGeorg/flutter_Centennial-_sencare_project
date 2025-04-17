import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sencare_project/constants/app_constants.dart';
import 'package:sencare_project/services/api_service.dart';
import 'package:sencare_project/services/navigation_service.dart';
import 'package:sencare_project/widgets/custom_bottom_bar.dart';
import 'package:sencare_project/widgets/logout_button.dart';
import 'package:sencare_project/screens/patients/resident_list_screen.dart';
import 'package:sencare_project/screens/tasks/task_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [];

  String _name = "";

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedName = prefs.getString('name') ?? "";

    // Populate the pages list before calling setState()
    final List<Widget> loadedPages = [
      HomeScreen(name: loadedName),
      ResidentListScreen(),
      TaskListScreen(),
    ];
    setState(() {
      _name = loadedName;
      _pages.addAll(loadedPages);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages.isNotEmpty
          ? _pages[_selectedIndex]
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _pages.isNotEmpty
          ? CustomBottomBar(
              selectedIndex: _selectedIndex, onItemTapped: _onItemTapped)
          : null,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String name;
  final apiService = ApiService();

  HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
      children: [
  //       Spacer(), 
        // Welcome Card with Logo
        Padding(   // Add padding here instead of outside the container
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
                color: const Color(0xFFB2F0D1),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                  )
                ]),
            child: Column(

              children: [
                Padding(   // Add padding here instead of outside the container
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Welcome $name',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                       Align(
                         alignment: Alignment.centerRight,
                         child: LogoutButton(),
                       )
                    ],
                  ),
                ),
              
              const SizedBox(height: 16),

              // const SizedBox(height: 16),

              // Notification Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ]),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Upcoming Shift',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Now',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            )
                          ],
                        ),
                        const Text('Tomorrow: Feb 20, Thursday 8 AM - 2 PM',
                            style: TextStyle(fontSize: 14))
                      ],
                    )),
                    const Icon(Icons.notifications_none, size: 24)
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Critical Patients Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB2F0D1).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Critical Patients',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12), // Patient Cards
                    FutureBuilder<List<Map<String, dynamic>>>(
                        future: apiService.fetchCriticalPatients('fetch'),
                        builder: (context, snapshot) {
                          print(
                              "Snapshot Connection State: ${snapshot.connectionState}");
                          if (snapshot.hasData) {
                            print("Snapshot Data: ${snapshot.data}");
                          }
                          if (snapshot.hasError) {
                            print("Snapshot Error: ${snapshot.error}");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            print("critic snapshot patient: ${snapshot.data} ");
                            return Column(
                              children: snapshot.data!
                                  .map((patient) => _buildPatientCard(
                                      patient['name'], patient['_id']))
                                  .toList(),
                            );
                          } else {
                            return const Text('No critical patients found.');
                          }
                        })

                    // _buildPatientCard('John Smith'),
                    // const SizedBox(height: 8),
                    // _buildPatientCard('Karake'),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Due Tasks Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB2F0D1).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Due Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Task Cards
                    _buildTaskCard('Medication'),
                    const SizedBox(height: 8),
                    _buildTaskCard('Feeding'),
                  ],
                ),
              )
            ],
          ),
        ),
        )
      ],
    )));
  }

  Widget _buildPatientCard(String name, String patientId) {
    print("Building patient card for: Name=$name, ID=$patientId");
    return GestureDetector(
        onTap: () {
          NavigationService.instance.navigateTo('/patientDetails',
              arguments: {'patientId': patientId});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ));
  }

  Widget _buildTaskCard(String task) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          task,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
