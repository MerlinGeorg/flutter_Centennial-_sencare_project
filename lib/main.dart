import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sencare_project/app.dart';
import 'package:sencare_project/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //runApp(const SenCareApp());

  await dotenv.load(fileName: ".env");

  final authService = await AuthService.instance;
  runApp(SenCareApp(authService: authService));
}

