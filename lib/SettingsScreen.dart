import 'package:flutter/material.dart';

import 'LoginBioScreen.dart';
import 'PasswordResetScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue[800], // Dark blue color for the AppBar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PasswordResetScreen(userId: '',)),
              );
            },
            child: const Text('Password Reset', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50), backgroundColor: Colors.blue[800], // Dark blue color for the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
              ),
            ),
          ),
          const SizedBox(height: 16), // Space between buttons
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginBioScreen()),
              );
            },
            child: const Text('Bio Login', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50), backgroundColor: Colors.blue[800], // Dark blue color for the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
              ),
            ),
          ),
        ],
      ),
    );
  }
}
