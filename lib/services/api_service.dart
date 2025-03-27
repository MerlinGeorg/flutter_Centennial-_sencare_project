import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  //ApiService(this.baseUrl);

  Future<dynamic> get(String route) async {
    try{
      final response = await http.get(Uri.parse('$baseUrl$route'));
      if(response.statusCode == 200) {
        print("patient: ${response.body} ");
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }
  }

  Future<dynamic> post(String route, Map<String, dynamic>body) async {
    try {
       print("inside post API");
      final response = await http.post(
        Uri.parse('$baseUrl$route'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body)
      );

      print("API response: $response");

      if(response.statusCode >= 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch(e) {
      throw Exception('Error during POST request: $e');
    }
  }

  Future<void> delete(String route) async{
    try {
      final response = await http.delete(Uri.parse('$baseUrl$route'));
      if(response.statusCode <= 200) {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during DELETE request: $e');
    }
  }

  Future<void> put(String route) async{
    try {
      final response = await http.put(Uri.parse('$baseUrl$route'));
      if(response.statusCode != 200) {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during PUT request: $e');
    }
  }
}