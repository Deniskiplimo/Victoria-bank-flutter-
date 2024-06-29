import 'package:flutter/material.dart';
import 'config.dart'; // Import the config file with APIs and responses
import 'Accounts.dart'; // Import the Account class

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late Future<List<Account>> futureAccounts;
  Account? selectedAccount;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool otpSent = false;

  @override
  void initState() {
    super.initState();
    futureAccounts = Config.fetchAccountsByCif('540000001'); // Corrected to use a string
  }

  Future<void> _withdrawFunds() async {
    if (selectedAccount == null) {
      _showErrorDialog('Please select an account');
      return;
    }

    final amount = double.tryParse(amountController.text);
    final phoneNumber = phoneNumberController.text;
    final otp = otpController.text;

    if (amount == null || amount <= 0) {
      _showErrorDialog('Please enter a valid amount');
      return;
    }

    if (phoneNumber.isEmpty) {
      _showErrorDialog('Please enter your phone number');
      return;
    }

    if (!otpSent) {
      _showErrorDialog('Please send the OTP first');
      return;
    }

    if (otp.isEmpty) {
      _showErrorDialog('Please enter the OTP sent to your phone');
      return;
    }

    try {
      final otpValid = await Config.verifyOtp(phoneNumber, otp);
      if (otpValid) {
        await Config.withdrawFunds(selectedAccount!.id.toString(), phoneNumber, amount);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Funds withdrawn successfully'),
            backgroundColor: Colors.green[700],
          ),
        );
        amountController.clear();
        phoneNumberController.clear();
        otpController.clear();
        setState(() {
          otpSent = false;
        });
      } else {
        _showErrorDialog('Invalid OTP');
      }
    } catch (e) {
      Config.handleApiError(e);
      _showErrorDialog('Failed to withdraw funds');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendOtp(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      _showErrorDialog('Please enter your phone number');
      return;
    }

    try {
      await Config.sendOtp(phoneNumber);
      setState(() {
        otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP sent successfully'),
          backgroundColor: Colors.green[700],
        ),
      );
    } catch (e) {
      Config.handleApiError(e);
      _showErrorDialog('Failed to send OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder<List<Account>>(
        future: futureAccounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Withdraw Funds',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Account>(
                    value: selectedAccount,
                    hint: const Text('Select Account'),
                    items: snapshot.data!.map((account) {
                      return DropdownMenuItem<Account>(
                        value: account,
                        child: Text(account.accountName),
                      );
                    }).toList(),
                    onChanged: (account) {
                      setState(() {
                        selectedAccount = account;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'From Account',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (otpSent)
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter OTP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _sendOtp(phoneNumberController.text),
                          child: const Text('Send OTP'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _withdrawFunds,
                          child: const Text('Withdraw Funds'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No accounts found'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
