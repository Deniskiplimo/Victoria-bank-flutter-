import 'package:flutter/material.dart';
import 'package:victoria/DashboardScreen.dart'; // Ensure the correct import path for DashboardScreen

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo, // Set the background color to indigo
      body: Stack(
        fit: StackFit.expand, // Make sure the Stack expands to fill the available space
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.98, // Image takes up 96% of the height of the screen
            child: Image.asset(
              'lib/assets/loginscreen.png', // Ensure this path is correct in your project
              fit: BoxFit.cover, // Cover the specified area
            ),
          ),
          // Form content on top of the image
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Position the form content downwards
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.8, // Form content covers the remaining height of the screen
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0), // Adjust vertical padding
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // Semi-transparent background for the form
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 0,
                          offset: Offset(0, 0), // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(30.0), // Padding inside the container
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Minimize column size to fit content
                      children: [
                        // Removed the header text
                        // const Text(
                        //   'Please Log In',
                        //   style: TextStyle(
                        //     fontSize: 24,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.blueAccent, // Color of the header text
                        //   ),
                        // ),
                        // const SizedBox(height: 24),
                        // Text fields for username and password
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            // Replace with your authentication logic
                            // For now, assume login is successful and navigate to DashboardScreen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const DashboardScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800], // Dark blue color for the button
                            minimumSize: const Size(double.infinity, 50), // Full-width button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
                            ),
                          ),
                          child: const Text('Submit', style: TextStyle(fontSize: 18, color: Colors.white)), // Button text
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
