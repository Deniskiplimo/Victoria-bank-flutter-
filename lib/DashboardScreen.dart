import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:victoria/LoginBioScreen.dart';
import 'PasswordResetScreen.dart'; // Import the PasswordResetScreen
import 'package:victoria/PasswordResetScreen.dart'; // Import the BiometricSettingsScreen
import 'LoansScreen.dart';
import 'LoginScreen.dart';
import 'Accounts.dart';
import 'DepositScreen.dart';
import 'SettingsScreen.dart';
import 'TransferScreen.dart';
import 'WithdrawScreen.dart';
import 'Transactions.dart';
import 'ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBalanceVisible = false;
  Future<List<Account>>? futureAccounts;
  Future<double>? futureBalance;
  String userName = 'User';
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadAccessToken();
    _fetchBalance();
  }

  Future<void> _loadUserName() async {
    futureAccounts = Config.fetchAccountsByCif('540000001');
    final accounts = await futureAccounts!;
    if (accounts.isNotEmpty) {
      setState(() {
        userName = accounts.first.accountName;
      });
    }
  }

  Future<void> _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('token');
    });
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    if (accessToken == null) return;

    final url = Uri.parse('http://102.210.244.222:6508/api/v1/account/balance');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final balance = data['balance'] as double;
      setState(() {
        futureBalance = Future.value(balance);
      });
    } else {
      throw Exception('Failed to fetch balance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _logout(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.blue[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.account_circle, size: 60, color: Colors.white),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        'Hello, $userName!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'What would you like to do today?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerButton(context, 'Reset Password', Icons.lock_reset, const PasswordResetScreen(userId: '',)),
              _buildDrawerButton(context, 'Biometric Authentication', Icons.fingerprint, const LoginBioScreen()),
              _buildDrawerButton(context, 'Logout', Icons.logout, () async {
                await _logout(context);
              }),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<double>(
                future: futureBalance,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final balance = snapshot.data ?? 0.0;
                    return _buildAccountBalanceCard(balance);
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Accounts',
                icon: Icons.account_balance_wallet,
                color: Colors.green,
                page: const AccountsScreen(),
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Products and Services',
                icon: Icons.shopping_cart,
                color: Colors.blueAccent,
                page: null,
                children: [
                  _buildServiceCard(
                    icon: Icons.attach_money,
                    title: 'Deposit',
                    color: Colors.orange,
                    page: const DepositScreen(),
                  ),
                  _buildServiceCard(
                    icon: Icons.money_off,
                    title: 'Withdraw',
                    color: Colors.red,
                    page: const WithdrawScreen(),
                  ),
                  _buildServiceCard(
                    icon: Icons.transfer_within_a_station,
                    title: 'Transfer',
                    color: Colors.lightBlue,
                    page: const TransferScreen(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Loans',
                icon: Icons.account_balance,
                color: Colors.purple,
                page: null,
                children: [
                  _buildServiceCard(
                    icon: Icons.receipt_long,
                    title: 'Apply for Loan',
                    color: Colors.deepPurple,
                    page: const LoansScreen(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Transactions',
                icon: Icons.receipt,
                color: Colors.teal,
                page: const Transactions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountBalanceCard(double balance) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Account Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  _isBalanceVisible ? '\$${balance.toStringAsFixed(2)}' : '******',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    Widget? page,
    List<Widget>? children,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: page != null ? const Icon(Icons.arrow_forward) : null,
            onTap: page != null
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
                : null,
          ),
          if (children != null)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                children: children,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget page,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }

  Widget _buildDrawerButton(BuildContext context, String title, IconData icon, dynamic action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (action is Widget) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => action),
          );
        } else if (action is Function) {
          action();
        }
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    final url = Uri.parse('http://102.210.244.222:6508/authentication/logout');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
        body: jsonEncode({
          'accessToken': accessToken,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log out: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }
}
