import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  // Define the image height factor here
  final double _imageHeightFactor = 0.5; // Set your desired height factor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
        backgroundColor: Colors.blue[800], // Dark blue color for the AppBar
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * _imageHeightFactor, // Adjust height based on _imageHeightFactor
            child: Image.asset(
              'lib/assets/passwordreset.png', // Ensure this path is correct in your project
              fit: BoxFit.cover,
            ),
          ),
          // Form content on top of the image
          Positioned.fill( // Use Positioned.fill to ensure the form fills the available space
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 150.0), // Adjust horizontal and vertical padding
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color to white
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: const Offset(0, 10), // Shadow position
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0), // Padding inside the container
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Minimize column size to fit content
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure full width for children
                  children: [
                    const SizedBox(height: 200), // Added space from the top
                    // Text field for Old Password
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Text field for New Password
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Text field for Confirm New Password
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Show a loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Simulate a delay for the password reset process
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context); // Dismiss the loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Password reset successful'),
                              backgroundColor: Colors.green[700], // Dark green color for the snack bar
                            ),
                          );
                        });
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
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
