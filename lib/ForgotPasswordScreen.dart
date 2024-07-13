import 'package:flutter/material.dart';
import 'PasswordResetScreen.dart';
import 'config.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _securityAnswerController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String? _securityQuestion;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchSecurityQuestion() async {
    setState(() {
      _errorMessage = null; // Clear any previous error message
    });

    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      setState(() {
        _errorMessage = 'User ID cannot be empty';
      });
      return;
    }

    try {
      final question = await Config.getSecurityQuestion(userId);
      setState(() {
        _securityQuestion = question as String?;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Display error message
      });
    }
  }

  Future<void> _verifySecurityAnswer() async {
    setState(() {
      _errorMessage = null; // Clear any previous error message
    });

    final userId = _userIdController.text.trim();
    final answer = _securityAnswerController.text.trim();

    if (userId.isEmpty || answer.isEmpty) {
      setState(() {
        _errorMessage = 'User ID and security answer cannot be empty';
      });
      return;
    }

    try {
      // Assuming questionId is always 1; adjust according to your real logic.
      final questionId = 1;
      final isValid = await Config.verifySecurityAnswer(userId, [questionId], [answer]);

      if (isValid) {
        // Navigate to PasswordResetScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetScreen(userId: userId),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Security question verification failed'; // Corrected error message
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Display security answer verification error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchSecurityQuestion,
              child: const Text('Get Security Question'),
            ),
            if (_securityQuestion != null) ...[
              const SizedBox(height: 16),
              Text(
                'Security Question: $_securityQuestion',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _securityAnswerController,
                decoration: const InputDecoration(
                  labelText: 'Answer to Security Question',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifySecurityAnswer,
                child: const Text('Verify Answer'),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
