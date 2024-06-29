import 'dart:async';
import 'package:flutter/material.dart';
import 'package:victoria/LoginScreen.dart'; // Replace with actual import path for LoginScreen
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _navigateToLoginScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToLoginScreen() {
    Timer(
      const Duration(seconds: 3), // Duration for the splash screen
          () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Victoria'),
        // Hide the app bar for splash screen if not needed
        // automaticallyImplyLeading: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'lib/assets/splashscreen.png',
            fit: BoxFit.cover,
          ),
          // Form content on top of the image
          Center(
            child: FadeTransition(
              opacity: _animation(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Splash screen image
                  Image.asset(
                    'lib/assets/splashscreen.png',
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  // Slack link button
                  ElevatedButton(
                    onPressed: () {
                      // Open Slack channel for feedback or support
                      _launchSlack();
                    },
                    child: const Text('Join Us on Slack'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Animation<double> _animation() {
    return Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _launchSlack() async {
    const url = 'https://join.slack.com/t/yourworkspace/shared_invite/enQtNDM1MjE5OTI2NzQ4LTkxZTMzMDE5MGQ4M2M1YjZlYjJmOGJhNTNlMzM4ZjRjNTczNjNlOWZlMmFiNTM5Y2FmMzU4YTQ5MWMwN2Y1Mzg'; // Replace with your Slack invite link
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
