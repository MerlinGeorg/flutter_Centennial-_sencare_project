

import 'package:flutter/material.dart';
import 'package:sencare_project/screens/login_screen.dart';
import 'package:sencare_project/screens/patients/add_patients_screen.dart';
import 'package:sencare_project/screens/register_screen.dart';
import 'package:sencare_project/screens/dashboard_screen.dart';
import 'package:sencare_project/screens/patients/edit_patients_screen.dart';
import 'package:sencare_project/screens/patients/new_patient_record_screen.dart';
import 'package:sencare_project/screens/patients/patient_details_screen.dart';
import 'package:sencare_project/screens/patients/resident_list_screen.dart';
import 'package:sencare_project/screens/tasks/task_list_screen.dart';

class AppRoutes {
  // Private constructor
  AppRoutes._();

  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String patients = '/patients';
  static const String tasks = '/tasks';
  static const String patientDetails = '/patientDetails';
  static const String addPatient = '/addPatient';
  static const String editPatient = '/editPatient';
  static const String newPatientRecord = '/newPatientRecord';
//  static const String taskDetails = '/tasks';


  // Route map
  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    dashboard: (context) => const DashboardScreen(),
    patients: (context) =>  ResidentListScreen(),
    tasks: (context) =>  TaskListScreen(), 
    patientDetails: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return PatientDetailsScreen(patientId: args['patientId']);
  },
     editPatient: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return EditPatientScreen(
        patientId: args['patientId'],
        // age: args['age']!,
        // healthStatus: args['healthStatus']!,
        // medicalHistory: args['medicalHistory']!,
        // roomNumber: args['roomNumber']!,
      );
    }, 
    newPatientRecord: (context) =>  NewPatientRecordScreen(),
    addPatient: (context) =>  AddPatientScreen(),
   // taskDetails: (context) =>  TaskListScreen(),    
  };
}