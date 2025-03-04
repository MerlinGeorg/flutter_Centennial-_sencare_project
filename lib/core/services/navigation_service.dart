

import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._privateConstructor();
  static final NavigationService _instance = NavigationService._privateConstructor();
  static NavigationService get instance => _instance;

  // Global navigation key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

   // Get current navigator state
   NavigatorState? get navigator => navigatorKey.currentState;

   // Navigate to a named route
   Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigator!.pushNamed(routeName, arguments: arguments);
   }

   // Replace current route
   Future<dynamic> replaceTo(String routeName, {Object? arguments}) {
    return navigator!.pushReplacementNamed(routeName, arguments: arguments);
   }

   // Push and remove all routes until the given route
   Future<dynamic> pushAndRemoveUntil(String routeName, {Object? arguments}) {
    return navigator!.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false, arguments: arguments);
   }

   // Go back
   void goBack() {
    return navigator!.pop();
   }
}