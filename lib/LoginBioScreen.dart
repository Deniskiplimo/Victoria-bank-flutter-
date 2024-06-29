import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'config.dart'; // Ensure this is the correct path to your config.dart file

class LoginBioScreen extends StatefulWidget {
  const LoginBioScreen({Key? key}) : super(key: key);

  @override
  _LoginBioScreenState createState() => _LoginBioScreenState();
}

class _LoginBioScreenState extends State<LoginBioScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      print("Can check biometrics: $canCheckBiometrics");
    } catch (e) {
      canCheckBiometrics = false;
      print("Error checking biometrics: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking biometrics: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      print("Starting biometric authentication");
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticating = false;
        _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      });

      print("Authentication result: $authenticated");

      if (authenticated) {
        print("Authenticated, now verifying with API");
        bool apiAuthenticated = await Config.authenticateBiometric('test_user'); // Replace 'test_user' with actual username
        if (apiAuthenticated) {
          print("API authentication successful");
          Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen or another screen
        } else {
          print("API authentication failed");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Biometric authentication failed'),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      }
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      print("PlatformException: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error - ${e.message}'),
          backgroundColor: Colors.red[700],
        ),
      );
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - $e';
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error - $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bio Login'),
        backgroundColor: Colors.blue[800],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/loginbio.png', // Corrected the image path to loginbio.png
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white10,
                      blurRadius: 10.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Bio Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _canCheckBiometrics ? _authenticateWithBiometrics : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: _isAuthenticating
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text('Login with Biometrics', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    if (!_canCheckBiometrics)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Biometric authentication is not available on this device',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to the settings screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800], // Blue color for the cancel button
                        minimumSize: const Size(double.infinity, 50), // Full-width button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.white)), // Button text
                    ),
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
