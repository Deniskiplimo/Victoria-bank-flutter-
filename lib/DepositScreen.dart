import 'package:flutter/material.dart';
import 'config.dart'; // Ensure this is the correct path to your config.dart file
import 'Accounts.dart'; // Import the Account class

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  late Future<List<Account>> futureAccounts;
  Account? selectedAccount;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;

  @override
  void initState() {
    super.initState();
    futureAccounts = Config.fetchAccountsByCif('540000001'); // Corrected to use a string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Deposit Screen',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Account>>(
              future: futureAccounts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return DropdownButton<Account>(
                    hint: const Text('Select Account'),
                    value: selectedAccount,
                    onChanged: (Account? newValue) {
                      setState(() {
                        selectedAccount = newValue;
                      });
                    },
                    items: snapshot.data!.map<DropdownMenuItem<Account>>((Account account) {
                      return DropdownMenuItem<Account>(
                        value: account,
                        child: Text(account.accountName), // Corrected to use accountName
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No accounts found');
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (isOtpSent)
              TextField(
                controller: otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedAccount != null &&
                    phoneNumberController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  if (!isOtpSent) {
                    await Config.sendOtp(phoneNumberController.text);
                    setState(() {
                      isOtpSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP sent to your phone')),
                    );
                  } else if (otpController.text.isNotEmpty) {
                    bool isVerified = await Config.verifyOtp(phoneNumberController.text, otpController.text);
                    if (isVerified) {
                      Config.initiateMpesaPrompt(
                        selectedAccount!.id.toString(),
                        phoneNumberController.text,
                        double.parse(amountController.text),
                      ).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('M-Pesa prompt initiated')),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $error')),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP verification failed')),
                      );
                    }
                  }
                }
              },
              child: Text(isOtpSent ? 'Verify OTP and Make a Deposit' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    amountController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
