import 'package:flutter/material.dart';
import 'config.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late Future<TransactionResponse> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = Config.fetchTransactions(); // Fetch transactions from API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: FutureBuilder<TransactionResponse>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final transactions = snapshot.data!.transactions;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: Icon(Icons.money_off),
                  title: Text(transaction.type),
                  subtitle: Text('Amount: \$${transaction.amount}'),
                );
              },
            );
          } else {
            return const Center(child: Text('No transactions available'));
          }
        },
      ),
    );
  }
}
