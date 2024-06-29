import 'package:flutter/material.dart';
import 'config.dart'; // Ensure this path is correct

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late Future<List<Account>> _accountsFuture;
  late Future<List<Account>> _creditFuture;
  late Future<List<Account>> _loanFuture;
  late Future<List<Account>> _fixedFuture;

  @override
  void initState() {
    super.initState();
    _accountsFuture = Config.fetchAccounts();
    _creditFuture = Config.fetchCreditAccounts();
    _loanFuture = Config.fetchLoanAccounts();
    _fixedFuture = Config.fetchFixedAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
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
            AccountsTab(future: _accountsFuture),
            AccountsTab(future: _creditFuture),
            AccountsTab(future: _loanFuture),
            AccountsTab(future: _fixedFuture),
          ],
        ),
      ),
    );
  }
}

class AccountsTab extends StatelessWidget {
  final Future<List<Account>> future;

  const AccountsTab({required this.future, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final accounts = snapshot.data!;
          if (accounts.isEmpty) {
            return const Center(child: Text('No accounts found'));
          }
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account.name),
                subtitle: Text('ID: ${account.id}'),
              );
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
