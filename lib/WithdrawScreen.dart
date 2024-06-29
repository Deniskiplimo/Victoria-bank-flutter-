import 'package:flutter/material.dart';
import 'config.dart'; // Import the config file with APIs and responses

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  List<Account> accounts = [];
  Account? selectedAccount;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool otpSent = false;
  String otp = '';

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Account> fetchedAccounts = await Config.fetchAccounts();
      setState(() {
        accounts = fetchedAccounts;
        isLoading = false;
      });
    } catch (e) {
      Config.handleApiError(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _withdrawFunds() async {
    if (selectedAccount == null) {
      _showErrorDialog('Please select an account');
      return;
    }

    final amount = double.tryParse(amountController.text);
    final phoneNumber = phoneNumberController.text;
    otp = otpController.text;

    if (amount == null || amount <= 0) {
      _showErrorDialog('Please enter a valid amount');
      return;
    }

    if (phoneNumber.isEmpty) {
      _showErrorDialog('Please enter your phone number');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        backgroundColor: Colors.blue[800],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
              items: accounts.map((account) {
                return DropdownMenuItem<Account>(
                  value: account,
                  child: Text(account.name),
                );
              }).toList(),
              onChanged: (account) {
                setState(() {
                  selectedAccount = account;
                  // Request OTP when an account is selected
                  if (account != null) {
                    _sendOtp(account.id.toString());
                  }
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
            ElevatedButton(
              onPressed: _withdrawFunds,
              child: const Text('Withdraw Funds'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOtp(String accountId) async {
    try {
      await Config.sendOtp(phoneNumberController.text);
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
}
