import 'package:flutter/material.dart';
import 'package:flutter_web/admin_dashboard.dart';
import '../services/auth_service.dart';
import 'services/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _surnameController = TextEditingController();
  final _employeeNumberController = TextEditingController();
  bool _isLoading = false;

  // Instance of the AuthService
  final AuthService _authService = AuthService();

  // Function to handle the login process
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Call the login function from AuthService
        final data = await _authService.login(
          _surnameController.text,
          _employeeNumberController.text,
        );

        // Retrieve the token from the response

        final token = data['accessToken'];
        print("Login successful, token: $token");

        // Store the token using TokenStorage
        await StorageManager.saveToken(token);

        // You can save the token in local storage or show a success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('You are logged in!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminDashboard()));
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        );
      } catch (error) {
        // Handle the error and show the failure message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _employeeNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/background.jpg",
                ),
                fit: BoxFit.cover)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 100, // Set desired width
                    height: 100, // Set desired height
                    child: Container(
                      decoration: BoxDecoration(
                        shape:
                            BoxShape.circle, // Circular background for the icon
                        color:
                            Colors.grey[300], // Background color for the circle
                      ),
                      child: const Icon(
                        Icons.person, // You can use other icons too
                        size: 60, // Set the icon size
                        color: Colors.blueAccent, // Set the icon color
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Text("Welcome Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _surnameController,
                        decoration: const InputDecoration(
                            labelText: 'Surname',
                            labelStyle: TextStyle(color: Colors.white)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your surname';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _employeeNumberController,
                        decoration: const InputDecoration(
                            labelText: 'Employee Number',
                            labelStyle: TextStyle(color: Colors.white)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your employee number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _login,
                              child: const Text('Login',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  )),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
