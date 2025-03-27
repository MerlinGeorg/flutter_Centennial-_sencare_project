


import 'package:sencare_project/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._privateConstructor() {
    _initPrefs();
  }
  static final AuthService _instance = AuthService._privateConstructor();
  static AuthService get instance => _instance;

  UserModel? _currentUser;
  UserModel? get currentUSer => _currentUser;

  late SharedPreferences _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> login(String email, String password) async {
    try {
    //  final prefs = await SharedPreferences.getInstance();

      // Retrieve stored credentials
      final storedEmail = _prefs.getString('email');
      final storedPassword = _prefs.getString('password');

      print('Stored Email: $storedEmail, Stored Password: $storedPassword');

      if(email == storedEmail && password== storedPassword) {
        print("login check success");
        await _prefs.setBool('isLoggedIn', true);

        // Create UserModel from stored data
        _currentUser = UserModel(
          id: _prefs.getString('id') ?? '',
          name: _prefs.getString('name') ?? '',
          email: email
        );
        print('IsLoggedIn: ${_prefs.getBool('isLoggedIn')}');

        return true;
      }
      return false;

    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try{
      // Store user data
      await _prefs.setString('id','user_${DateTime.now().millisecondsSinceEpoch}');
      await _prefs.setString('name', name);
      await _prefs.setString('email', email);
      await _prefs.setString('password', password);

      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
   //   final prefs = await SharedPreferences.getInstance();
   _prefs.setBool('isLoggedIn', false);
      _currentUser = null;
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }


}