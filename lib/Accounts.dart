import 'package:flutter/material.dart';
import 'config.dart'; // Ensure this is the correct path to your config.dart file
import 'Accounts.dart'; // Import the Account class

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late Future<List<Account>> futureAccounts;
  final String cif = '540000001';

  bool _showBalance = false; // State to control balance visibility

  late List<Account> _allAccounts = [];
  late List<Account> _creditAccounts = [];
  late List<Account> _loanAccounts = [];
  late List<Account> _fixedAccounts = [];

  @override
  void initState() {
    super.initState();
    futureAccounts = Config.fetchAccountsByCif(cif);

    futureAccounts.then((accounts) {
      categorizeAccounts(accounts);
    }).catchError((error) {
      print('Error fetching accounts: $error');
    });
  }

  void categorizeAccounts(List<Account> accounts) {
    setState(() {
      for (var account in accounts) {
        _allAccounts.add(account);
        switch (account.type) {
          case 'Credit':
            _creditAccounts.add(account);
            break;
          case 'Loan':
            _loanAccounts.add(account);
            break;
          case 'Fixed':
            _fixedAccounts.add(account);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accounts'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Accounts'),
              Tab(text: 'Credit'),
              Tab(text: 'Loan'),
              Tab(text: 'Fixed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AccountsTab(
              accounts: _allAccounts,
              type: 'All Accounts',
              showBalance: _showBalance,
              onToggleBalance: () {
                setState(() {
                  _showBalance = !_showBalance;
                });
              },
            ),
            AccountsTab(
              accounts: _creditAccounts,
              type: 'Credit Accounts',
              showBalance: _showBalance,
              onToggleBalance: () {
                setState(() {
                  _showBalance = !_showBalance;
                });
              },
            ),
            AccountsTab(
              accounts: _loanAccounts,
              type: 'Loan Accounts',
              showBalance: _showBalance,
              onToggleBalance: () {
                setState(() {
                  _showBalance = !_showBalance;
                });
              },
            ),
            AccountsTab(
              accounts: _fixedAccounts,
              type: 'Fixed Accounts',
              showBalance: _showBalance,
              onToggleBalance: () {
                setState(() {
                  _showBalance = !_showBalance;
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showBalance = !_showBalance;
            });
          },
          child: Icon(
            _showBalance ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}

class AccountsTab extends StatelessWidget {
  final List<Account>? accounts;
  final String type;
  final bool showBalance;
  final VoidCallback onToggleBalance;

  const AccountsTab({
    this.accounts,
    required this.type,
    required this.showBalance,
    required this.onToggleBalance,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (accounts == null || accounts!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: accounts!.length,
        itemBuilder: (context, index) {
          final account = accounts![index];
          return CardHolder(
            accountName: account.accountName ?? 'Unknown',
            balance: account.balance ?? 0.0,
            showBalance: showBalance,
            onToggle: onToggleBalance,
            accountType: type,
          );
        },
      );
    }
  }
}

class CardHolder extends StatelessWidget {
  final String accountName;
  final double balance;
  final bool showBalance;
  final VoidCallback onToggle;
  final String accountType;

  const CardHolder({
    Key? key,
    required this.accountName,
    required this.balance,
    required this.showBalance,
    required this.onToggle,
    required this.accountType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          accountName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          showBalance ? '\$${balance.toStringAsFixed(2)}' : '•••••••••',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[700],
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            showBalance ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue[700],
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
