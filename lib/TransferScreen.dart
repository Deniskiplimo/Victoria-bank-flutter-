import 'package:flutter/material.dart';
import 'config.dart'; // Import the config file with APIs and responses
import 'Accounts.dart'; // Import the Account class

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late Future<List<Account>> futureAccounts;
  Account? selectedAccount;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController toAccountController = TextEditingController();
  bool _isTransferToOwnAccount = true; // Added a flag to determine transfer type

  @override
  void initState() {
    super.initState();
    futureAccounts = Config.fetchAccountsByCif('540000001'); // Corrected to use a string
  }

  Future<void> _transferFunds() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      _showErrorDialog('Please enter a valid amount');
      return;
    }

    if (_isTransferToOwnAccount) {
      if (selectedAccount == null) {
        _showErrorDialog('Please select an account');
        return;
      }

      try {
        await Config.transferFunds(
          selectedAccount!.id.toString(),
          selectedAccount!.id.toString(), // Transfer within the same account
          amount,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Funds transferred successfully'),
            backgroundColor: Colors.green[700],
          ),
        );
      } catch (e) {
        Config.handleApiError(e);
        _showErrorDialog('Failed to transfer funds');
      }
    } else {
      final toAccountId = toAccountController.text;

      if (toAccountId.isEmpty) {
        _showErrorDialog('Please enter the destination account ID');
        return;
      }

      try {
        await Config.transferFunds(
          selectedAccount!.id.toString(),
          toAccountId,
          amount,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Funds transferred successfully'),
            backgroundColor: Colors.green[700],
          ),
        );
      } catch (e) {
        Config.handleApiError(e);
        _showErrorDialog('Failed to transfer funds');
      }
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
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Funds'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Account>>(
          future: futureAccounts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No accounts found'));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Radio buttons to select transfer type
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Transfer to My Own Account'),
                          value: true,
                          groupValue: _isTransferToOwnAccount,
                          onChanged: (bool? value) {
                            setState(() {
                              _isTransferToOwnAccount = value ?? true;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Transfer to Other Account'),
                          value: false,
                          groupValue: _isTransferToOwnAccount,
                          onChanged: (bool? value) {
                            setState(() {
                              _isTransferToOwnAccount = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_isTransferToOwnAccount) ...[
                    // DropdownButtonFormField for account selection
                    DropdownButtonFormField<Account>(
                      value: selectedAccount,
                      hint: const Text('Select Account'),
                      onChanged: (Account? newValue) {
                        setState(() {
                          selectedAccount = newValue;
                        });
                      },
                      items: snapshot.data!.map<DropdownMenuItem<Account>>((Account account) {
                        return DropdownMenuItem<Account>(
                          value: account,
                          child: Text(account.accountName), // Assuming `accountName` is the property to display
                        );
                      }).toList(),
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      menuMaxHeight: 300, // Increased the max height of the dropdown menu
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isTransferToOwnAccount) ...[
                    TextField(
                      controller: toAccountController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'To Account ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: _transferFunds,
                    child: const Text('Transfer Funds'),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No accounts found'));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    toAccountController.dispose();
    super.dispose();
  }
}
