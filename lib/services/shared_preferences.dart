import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  // Save token to SharedPreferences
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  // Retrieve token from SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Remove token from SharedPreferences
  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }
}
