import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL for your API
  final String _baseUrl =
      'http://localhost:3000/api'; // Replace with your actual backend API base URL

  // Function to handle login
  Future<Map<String, dynamic>> login(
      String surname, String employeeNumber) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'surname': surname,
        'employeeNumber': employeeNumber,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(
          response.body); // Returns the response body, which includes the token
    } else {
      throw Exception('Failed to login. Error: ${response.statusCode}');
    }
  }
}
