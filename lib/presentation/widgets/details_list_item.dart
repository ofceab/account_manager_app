import 'package:flutter/material.dart';

import 'alert_dialog.dart';

class DetailsListItem extends StatelessWidget {
  final String date;
  final double credit;
  final double debit;
  final String particular;
  final int indexOfTransaction;
  final Function addFunction;

  DetailsListItem({
    this.date,
    this.addFunction,
    this.particular,
    this.credit,
    this.debit,
    this.indexOfTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        onSelected: (String value) => _handlePopMenuAction(context, value),
        child: Row(children: <Widget>[
          Text(date),
          Text(particular),
          Text(credit.toString()),
          Text(debit.toString())
        ]),
        itemBuilder: (context) {
          return ['Edit', 'Delete'].map((operation) {
            return PopupMenuItem(
                value: operation,
                child: Row(
                  children: [
                    Icon(operation == 'Edit' ? Icons.edit : Icons.remove),
                    Text(operation)
                  ],
                ));
          }).toList();
        });
  }

  //Handle actions
  _handlePopMenuAction(BuildContext context, String value) {
    if (value == 'Edit') {
      showDialog(
          context: context,
          child: AddTransactionDialog(
            addFunction: this.addFunction,
            credit: credit,
            debit: debit,
            date: date,
            indexOfTransaction: indexOfTransaction,
            particular: particular,
          ));
    }
  }
}
