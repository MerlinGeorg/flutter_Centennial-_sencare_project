

import 'package:flutter/material.dart';

class AppTheme {
   // Private constructor to prevent instantiation
   AppTheme._();

   // App colors
   static const Color primaryColor = Color(0XFFB2F1D2);
   static const Color backgroundColor = Color(0XFFD8FDE9);
   static const Color textColor = Colors.black;
   static const Color hintColor = Colors.grey;

   // Light theme
   static final ThemeData lightTheme = ThemeData(

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w500
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 16
        )
      )
   );
}