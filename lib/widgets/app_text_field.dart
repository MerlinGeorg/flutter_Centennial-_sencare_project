

import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final bool obsureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obsureText = false,
    this.keyboardType = TextInputType.text,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText
      ),
    );
  }
}