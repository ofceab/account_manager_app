import 'package:account_manager_app/helpers/appTheme.dart';
import 'package:account_manager_app/models/transaction.dart';
import 'package:account_manager_app/models/user_transaction.dart';
import 'package:account_manager_app/presentation/widgets/alert_dialog.dart';
import 'package:account_manager_app/presentation/widgets/details_list_item.dart';
import 'package:flutter/material.dart';

class DetailsList extends StatelessWidget {
  final User user;
  const DetailsList({@required this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _buildFLoatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: Text(this.user.name),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.library_add_outlined),
                onPressed: () => _showDialog(context))
          ],
        ),
        body: Container(
            child: (user.transactionList.length == 0)
                ? Center(child: Text('No transactions yet'))
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return DetailsListItem(
                        addFunction: _addFunction,
                        credit: user.transactionList[index].credit,
                        debit: user.transactionList[index].debit,
                        date: user.transactionList[index].transactionDate,
                        indexOfTransaction: index,
                        particular: user.transactionList[index].particular,
                      );
                    },
                  )));
  }

  //Build floatingAction Button
  Padding get _buildFLoatingActionButton => Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.smallSpacing + 5),
        child: FloatingActionButton(
          onPressed: () {
            //TODO
            //ADD THE function to download the file
          },
          child: Icon(Icons.download_rounded, color: AppTheme.creditColor),
          tooltip: 'Create a user',
        ),
      );

  //Build table row of the table,
  Row _buildTableRow(
          {String date,
          String particular,
          String credit,
          String debit,
          String type}) =>
      Row(children: <Widget>[
        Text(date),
        Text(particular),
        Text(credit),
        Text(debit),
      ]);

  //Build header of the table,
  Row _buildHeader() => _buildTableRow(
      date: 'Date',
      credit: 'Credit (€)',
      debit: 'Credit (€)',
      particular: 'Particular',
      type: 'header');

  //SHow ALertDialog
  _showDialog(context) {
    showDialog(
        context: context, child: AddTransactionDialog(addFunction: _addFunction));
  }

  //addFunction declaration
  void _addFunction(Transaction transaction, {String operationType: 'add'}) {
    user.transactionList.add(transaction);
  }
}
