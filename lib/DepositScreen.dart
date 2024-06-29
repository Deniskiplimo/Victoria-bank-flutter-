import 'package:flutter/material.dart';
import 'config.dart';
import 'config.dart'; // Ensure this is the correct path to your config.dart file

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

  @override
  void initState() {
    super.initState();
    futureAccounts = Config.fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: Center(
        child: Padding(
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
                          child: Text(account.name),
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
              ElevatedButton(
                onPressed: () {
                  if (selectedAccount != null &&
                      phoneNumberController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
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
                  }
                },
                child: const Text('Make a Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
