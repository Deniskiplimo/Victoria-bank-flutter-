import 'package:flutter/material.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: const Text('Loan functionalities will be here'),
      ),
    );
  }
}
