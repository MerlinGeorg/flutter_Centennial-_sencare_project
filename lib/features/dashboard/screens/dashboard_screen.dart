import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sencare_project/core/constants/app_constants.dart';
import 'package:sencare_project/core/widgets/custom_bottom_bar.dart';
import 'package:sencare_project/core/widgets/logout_button.dart';
import 'package:sencare_project/features/patients/resident_list_screen.dart';
import 'package:sencare_project/features/tasks/task_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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
      bottomNavigationBar: _pages.isNotEmpty ? CustomBottomBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped) : null,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
           child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, 
            children: [LogoutButton()]
          ),
        ),

        // Welcome Card with Logo
        Container(
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
              Text('Welcome $name',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),

              const SizedBox(height: 8),

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
                    const SizedBox(height: 12),
                    // Patient Cards
                    _buildPatientCard('John Smith'),
                    const SizedBox(height: 8),
                    _buildPatientCard('Karake'),
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
        )
      ],
    )
      )
     
    );
  }

  Widget _buildPatientCard(String name) {
    return Container(
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
    );
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
