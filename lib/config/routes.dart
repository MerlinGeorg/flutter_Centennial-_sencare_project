

import 'package:flutter/material.dart';
import 'package:sencare_project/features/auth/screens/login_screen.dart';
import 'package:sencare_project/features/auth/screens/register_screen.dart';
import 'package:sencare_project/features/dashboard/screens/dashboard_screen.dart';
import 'package:sencare_project/features/patients/resident_list_screen.dart';
import 'package:sencare_project/features/tasks/task_list_screen.dart';

class AppRoutes {
  // Private constructor
  AppRoutes._();

  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String patients = '/patients';
  static const String tasks = '/tasks';


  // Route map
  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    dashboard: (context) => const DashboardScreen(),
    patients: (context) =>  ResidentListScreen(),
    tasks: (context) =>  TaskListScreen(),    
  };
}