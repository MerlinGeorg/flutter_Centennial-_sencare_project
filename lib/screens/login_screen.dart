

import 'package:flutter/material.dart';
import 'package:sencare_project/config/routes.dart';
import 'package:sencare_project/constants/app_constants.dart';
import 'package:sencare_project/services/navigation_service.dart';
import 'package:sencare_project/widgets/app_text_field.dart';
import 'package:sencare_project/screens/register_screen.dart';
import 'package:sencare_project/services/auth_service.dart';
import 'package:sencare_project/widgets/auth_button.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to manage user input for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

// Global key to manage the form state (validation, submission, etc.)
  final _formKey = GlobalKey<FormState>();

  // Boolean to track login button loading state
  bool _isLoading = false;

  @override
  void dispose() {
    // Disposing controllers to free memory when widget is destroyed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator while logging in
      });

      try {
        final success = await AuthService.instance.login(
          _emailController.text,
          _passwordController.text
          );

          print("success data: ${success}");

        if(success && mounted) {
          print("navigation check: ");
           // Navigate to dashboard and remove all previous routes
          NavigationService.instance.pushAndRemoveUntil(AppRoutes.dashboard);
      //   Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.dashboard, (Route<dynamic> route) => false);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Credentials'))
          );
        }
      } catch (e, stacktrace) {
  print("Login error: $e");
  print("Stacktrace: $stacktrace");
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occured.Please try again later.'))
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                  ),
                ),

                // App Name
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),

                // Login Text
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Email Field
                AppTextField(
                  controller: _emailController,
                  hintText: 'Enter Your Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if(!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                AppTextField(
                  controller: _passwordController,
                   hintText: 'Password',
                  obsureText: true,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Login Button
                AuthButton(
                  text: 'Log In',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 16),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have account?',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14
                    ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => const RegisterScreen())
                        );
                      },
                      child: const Text('Register Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),
                      ),
                    )

                ],)
              ],
            ),
          )
        )))
    );
  }
}