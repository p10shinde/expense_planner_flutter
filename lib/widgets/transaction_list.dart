import 'package:expense_planner/widgets/transaction_item.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * .6,
                  child: Image.asset(
                    'assets/images/empty.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
              ],
            );
          })
        : ListView(
            children: userTransactions
                .map((tx) =>
                      TransactionItem(
                        key: ValueKey(tx.id),
                        userTransaction: tx,
                        deleteTransaction: deleteTransaction,
                      )
                    )
                .toList(),
          );
    // : ListView.builder(
    //     itemCount: userTransactions.length,
    //     itemBuilder: (ctx, index) {
    //       return TransactionItem(userTransaction: userTransactions[index], deleteTransaction: deleteTransaction,);
    //     },
    //   );
  }
}
