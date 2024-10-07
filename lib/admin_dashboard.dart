import 'package:flutter/material.dart';
import 'dart:convert'; // For API request
import 'package:http/http.dart' as http;

import 'services/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic> apiStats = {
    'totalRequests': 0,
    'successfulRequests': 0,
    'failedRequests': 0,
  };

  @override
  void initState() {
    super.initState();
    fetchApiStats();
  }

  Future<void> fetchApiStats() async {
    String? token = await StorageManager.getToken();

    final response = await http.get(
      Uri.parse('http://localhost:3000/api/admin/performance'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        // Extract the data field from the response and update apiStats
        apiStats = jsonResponse['data'];
      });
    } else {
      print("Failed to load API stats");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "API Performance Dashboard",
          style: TextStyle(color: Color.fromARGB(255, 5, 79, 139)),
        ),
        centerTitle: true,
      ),
      drawer: buildSideNavBar(), // Add the drawer (side navigation bar)
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildStatsCard("Total Requests", apiStats['totalRequests']),
                    const SizedBox(width: 10),
                    buildStatsCard(
                        "Successful Requests", apiStats['successfulRequests']),
                    const SizedBox(width: 10),
                    buildStatsCard(
                        "Failed Requests", apiStats['failedRequests']),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: fetchApiStats,
                child: const Text(
                  "Refresh Stats",
                  style: TextStyle(color: Color.fromARGB(255, 5, 79, 139)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Safely handle null values by providing a default value (0)
  Widget buildStatsCard(String title, dynamic value) {
    int displayValue =
        value != null ? value as int : 0; // If null, default to 0
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding inside the card
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), // Add spacing between text and value
            Text(
              displayValue.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  // Build the side navigation bar (Drawer)
  Drawer buildSideNavBar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 5, 79, 139),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Dashboard',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                SizedBox(height: 8),
                Text('Welcome, Admin',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              // Handle Dashboard navigation here
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Handle Profile navigation here
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle Settings navigation here
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle Logout navigation here
              Navigator.pop(context); // Close the drawer
              // You can navigate to the login screen or handle logout logic here
            },
          ),
        ],
      ),
    );
  }
}
