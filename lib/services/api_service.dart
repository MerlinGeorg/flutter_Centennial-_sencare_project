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

  
  Future<List<Map<String, dynamic>>> fetchCriticalPatients(String route) async {
    try{
      final response = await http.get(Uri.parse('$baseUrl$route'));
      if(response.statusCode == 200)  {
        final dynamic decodedBody = json.decode(response.body);

      if (decodedBody is List) {
        print("critic patient: ${decodedBody} ");

        List<Map<String, dynamic>> criticalPatients = decodedBody
        .where((patient)=> patient['health_status'] == 'Critical')
        .map<Map<String, dynamic>>((patient)=> {
         'name': patient['name'],
         '_id': patient['_id']
        })
        .toList();

        return criticalPatients;
     }  else {
        print("Error: Decoded body is not a List");
        return [];
      }
    }
    return [];
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }


  //   return [
  //   {'name': 'Dal Fig', '_id': '67321705bb77868c8c478dc3'},
  // ];
  }

  Future<List<Map<String, dynamic>>>fetchMedicalTests(String route) async {
  final response = await http.get(Uri.parse('$baseUrl$route'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch records');
  }
  }

Future<dynamic> addNewMedicalTest(String route, Map<String, dynamic> body) async {
   try {
     print('🗂️ Sending POST to: $baseUrl$route');
    print('📦 Payload: $body');
  final response = await http.post(
    Uri.parse('$baseUrl$route'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );
    print('🔔 Response Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body}');
  print(response);
  if (response.statusCode == 200 || response.statusCode == 201) {
    return json.decode(response.body);
  } else {
   throw Exception('''
🚨 API Error ${response.statusCode}
📌 Details: ${response.body}
''');
   // throw Exception('Failed to add new medical test: ${response.statusCode}');
  }
  } catch (e, stackTrace) {
    print('''💥 Critical Error:
$e
🔍 Stack Trace:
$stackTrace''');
    rethrow;
  }
}


  Future<List<Map<String, dynamic>>>editMedicalTest(String route) async {
  final response = await http.get(Uri.parse('$baseUrl$route'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch records');
  }
  }
}