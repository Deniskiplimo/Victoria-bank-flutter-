import 'package:flutter/material.dart';
import 'Accounts.dart';
import 'DepositScreen.dart';
import 'SettingsScreen.dart';
import 'TransferScreen.dart';
import 'WithdrawScreen.dart';
import 'Transactions.dart'; // Import the Transactions page

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: <Widget>[
          _buildNavigationButton(context, 'Withdraw', const WithdrawScreen()),
          _buildNavigationButton(context, 'Transfer', const TransferScreen()),
          _buildNavigationButton(context, 'Accounts', const AccountsScreen()),
          _buildNavigationButton(context, 'Deposit', const DepositScreen()),
          _buildNavigationButton(context, 'Settings', const SettingsScreen()),
          _buildNavigationButton(context, 'Transactions', const Transactions()), // Add Transactions button
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Set the background color to blue
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 18, // Font size
                fontWeight: FontWeight.bold, // Font weight
              ),
            ),
          ),
        ),
      ),
    );
  }
}
