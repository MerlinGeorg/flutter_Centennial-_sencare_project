

import 'package:flutter/material.dart';
import 'package:sencare_project/core/services/navigation_service.dart';
import 'package:sencare_project/features/auth/services/auth_service.dart';

class LogoutButton extends StatelessWidget{

  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    
    return IconButton(
      onPressed: () async {
        bool success = await AuthService.instance.logout();
        if(success) {
          NavigationService.instance.replaceTo('/login');
        }
      },
     icon: SizedBox(
              width: 24,
              height: 24,
              child:  Image.asset('assets/logout_icon.png')
              )
          );
  } 
}