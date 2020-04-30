import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  
  const TransactionItem({
    Key key,
    @required this.userTransaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction userTransaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    final availableColors = [Colors.red, Colors.blue, Colors.purple, Colors.green];
    final _bgColor = availableColors[Random().nextInt(4)];

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '₹${userTransaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          userTransaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(userTransaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () {
                  deleteTransaction(userTransaction.id);
                },
                textColor: Theme.of(context).errorColor,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Delete'),
              )
            : IconButton(
                color: Theme.of(context).errorColor,
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  deleteTransaction(userTransaction.id);
                },
              ),
      ),
    );
  }
}
