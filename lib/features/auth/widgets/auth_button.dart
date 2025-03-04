

import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
       child: isLoading ?
                const SizedBox(
                  height: 20, width: 20, 
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ) :
                Text(text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),)
    );
  }
}