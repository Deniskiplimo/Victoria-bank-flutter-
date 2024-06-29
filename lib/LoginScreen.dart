import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DashboardScreen.dart'; // Ensure the correct import path for DashboardScreen
import 'ForgotPasswordScreen.dart'; // Import the ForgotPasswordScreen
import 'config.dart';  // Ensure the correct import path for your Config class

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _errorMessage;
  bool _isOtpSent = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();
  }

  Future<void> _checkFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isOtpVerified = prefs.getBool('isOtpVerified') ?? false;

    setState(() {
      _isOtpSent = !isOtpVerified;
    });
  }

  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null; // Clear any previous error message
    });

    try {
      final userId = _userIdController.text.trim();
      final password = _passwordController.text.trim();

      if (userId.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Username and password cannot be empty';
        });
        return;
      }

      // Authenticate the user
      final response = await Config.authenticateUser(userId, password);

      // Check for first login
      final firstLogin = response['entity']['firstLogin'] ?? false;

      if (firstLogin) {
        await Config.sendOtp(userId);
        setState(() {
          _isOtpSent = true; // Update state to show OTP field
        });
      } else {
        // Save the access token if needed
        final accessToken = response['entity']['access_token'];
        // Save the access token in shared preferences or any secure storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken ?? '');

        // Navigate to DashboardScreen on successful login without OTP
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Display error message
      });
    }
  }

  Future<void> _handleOtpVerification() async {
    setState(() {
      _errorMessage = null; // Clear any previous error message
    });

    try {
      final userId = _userIdController.text.trim();
      final otp = _otpController.text.trim();

      if (otp.isEmpty) {
        setState(() {
          _errorMessage = 'OTP cannot be empty';
        });
        return;
      }

      // Verify OTP
      final otpValid = await Config.verifyOtp(userId, otp);

      if (otpValid) {
        // Store OTP verification status
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isOtpVerified', true);

        // Navigate to the DashboardScreen on successful OTP verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'OTP verification failed'; // Corrected error message
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Display OTP verification error
      });
    }
  }

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
            height: MediaQuery.of(context).size.height * 0.98, // Image takes up 98% of the height of the screen
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
                          color: Colors.black26,
                          blurRadius: 8.0, // Adjust shadow blur
                          offset: Offset(0, 4), // Shadow position
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(30.0), // Padding inside the container
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Minimize column size to fit content
                      children: [
                        Icon(Icons.lock_outline, size: 100, color: Colors.blue[800]), // Icon at the top
                        const SizedBox(height: 16),
                        Text(
                          'Login to Your Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800], // Text color for the title
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _userIdController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: Colors.blue[800]), // Icon for the username field
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.blue[800]), // Icon for the password field
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                          ),
                        ),
                        if (_isOtpSent) ...[
                          const SizedBox(height: 24),
                          TextField(
                            controller: _otpController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_open, color: Colors.blue[800]), // Icon for the OTP field
                              labelText: 'OTP',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Adjust text field height
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isOtpSent ? _handleOtpVerification : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue[800], // Text color
                            minimumSize: Size(double.infinity, 50), // Full-width button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
                            ),
                          ),
                          child: Text(
                            _isOtpSent ? 'Verify OTP' : 'Submit',
                            style: const TextStyle(fontSize: 18, color: Colors.white), // Button text
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red), // Display error message
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
