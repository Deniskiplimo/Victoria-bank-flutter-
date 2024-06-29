import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'DashboardScreen.dart';
import 'SplashScreen.dart'; // Ensure the correct import path for SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure the widget binding is initialized
  final prefs = await SharedPreferences.getInstance();
  final isOtpVerified = prefs.getBool('isOtpVerified') ?? false;

  runApp(MyApp(isOtpVerified: isOtpVerified));
}

class MyApp extends StatelessWidget {
  final bool isOtpVerified;

  const MyApp({Key? key, required this.isOtpVerified}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isOtpVerified ? const DashboardScreen() : const SplashScreen(), // Show DashboardScreen if OTP is verified, otherwise show SplashScreen
    );
  }
}
