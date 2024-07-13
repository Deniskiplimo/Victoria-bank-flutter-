import 'package:flutter/material.dart';
import 'config.dart';

class PasswordResetScreen extends StatefulWidget {
  final String userId;

  const PasswordResetScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  String? _successMessage;

  Future<void> _resetPassword() async {
    setState(() {
      _errorMessage = null;  // Clear any previous error message
      _successMessage = null;  // Clear any previous success message
    });

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'New password and confirmation do not match';
      });
      return;
    }

    try {
      await Config.resetPassword(widget.userId, oldPassword, newPassword, confirmPassword);
      setState(() {
        _successMessage = 'Password reset successful';  // Set the success message
      });

      // Navigate to the login screen or another screen
      Navigator.of(context).pop();  // Returning to the previous screen
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();  // Display password reset error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Old Password',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Reset Password'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            if (_successMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _successMessage!,
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
