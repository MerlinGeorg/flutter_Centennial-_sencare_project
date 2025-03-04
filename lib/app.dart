

import 'package:flutter/material.dart';
import 'package:sencare_project/config/routes.dart';
import 'package:sencare_project/config/theme.dart';
import 'package:sencare_project/core/services/navigation_service.dart';
import 'package:sencare_project/features/auth/screens/login_screen.dart';
import 'package:sencare_project/features/auth/services/auth_service.dart';

class SenCareApp extends StatelessWidget {

  final AuthService authService;

  //const SenCareApp({super.key});
  const SenCareApp({Key? key, required this.authService}) : super(key: key);


 // bool isLoggedIn = AuthService.instance.isLoggedIn;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SenCare',
      theme: AppTheme.lightTheme,
    //  home: const LoginScreen(),
  //  initialRoute: isLoggedIn? AppRoutes.dashboard: AppRoutes.login,
    initialRoute: AppRoutes.login,
    routes: AppRoutes.routes,
    navigatorKey: NavigationService.instance.navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}