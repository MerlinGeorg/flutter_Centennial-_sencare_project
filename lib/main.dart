import 'package:flutter/material.dart';
import 'package:sencare_project/app.dart';
import 'package:sencare_project/features/auth/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //runApp(const SenCareApp());

  final authService = await AuthService.instance;
  runApp(SenCareApp(authService: authService));
}

