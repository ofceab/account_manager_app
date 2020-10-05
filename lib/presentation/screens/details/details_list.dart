import 'package:account_manager_app/cubit/rebuild_fixer.dart';
import 'package:account_manager_app/helpers/appTheme.dart';
import 'package:account_manager_app/models/transaction.dart' as Transaction;
import 'package:account_manager_app/models/user_transaction.dart';
import 'package:account_manager_app/presentation/screens/error/error.dart';
import 'package:account_manager_app/presentation/screens/loading/loading.dart';
import 'package:account_manager_app/presentation/widgets/alert_dialog.dart';
import 'package:account_manager_app/presentation/widgets/details_list_item.dart';
import 'package:account_manager_app/services/transaction_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsList extends StatelessWidget {
  final User user;
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;
  DetailsList({@required this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        floatingActionButton: _buildFLoatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: Text(this.user.name),
          centerTitle: true,
          actions: [
            StreamBuilder(
              stream: _transactionService.fetchOneUsersTransaction(
                  userID: user.userID),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  DocumentSnapshot _doc = snapshot.data;
                  User _user = User.fromDocumentSnaphot(_doc.id, _doc.data());
                  return IconButton(
                      icon: Icon(Icons.library_add_outlined),
                      onPressed: () => _showDialog(context, _user));
                }
                return Loading();
              },
            )
          ],
        ),
        body: BlocBuilder<RebuildFixer, bool>(builder: (context, unsedVal) {
          return StreamBuilder<DocumentSnapshot>(
              stream: _transactionService.fetchOneUsersTransaction(
                  userID: user.userID),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  DocumentSnapshot _doc = snapshot.data;
                  User _user = User.fromDocumentSnaphot(_doc.id, _doc.data());

                  if (_user.transactionList.length == 0) {
                    return Center(child: Text('No transactions yet'));
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildHeader(),
                      ),
                      _buildList(_user)
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
        }));
  }

  //This function build the entire Transaction Items
  SliverList _buildList(User _user) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return DetailsListItem(
          user: _user,
          addFunction: _addFunction,
          credit: _user.transactionList[index].credit,
          debit: _user.transactionList[index].debit,
          date: _user.transactionList[index].transactionDate,
          indexOfTransaction: index,
          particular: _user.transactionList[index].particular,
        );
      }, childCount: _user.transactionList.length),
    );
  }

  Container _buildHeader() {
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.creditColor,
            borderRadius: BorderRadius.circular(25)),
        margin: const EdgeInsets.only(top: 7, left: 7, right: 7),
        child: ListTile(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Date'),
                Text('Particular'),
                Text('Credit'),
                Text('Debit')
              ]),
        ));
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

  //SHow ALertDialog
  _showDialog(context, User user) {
    showDialog(
        context: context,
        child: AddTransactionDialog(user: user, addFunction: _addFunction));
  }

  //addFunction declaration
  void _addFunction(Transaction.Transaction transaction, User user,
      {int indexOfTransaction, String operationType: 'add'}) {
    assert(user != null);
    if (operationType == 'add') {
      user.transactionList.add(transaction);
      _transactionService.addAndUpdateuserTransactionsList(
          docId: user.userID,
          newTransactionList: user.getMappedTransactionList);
    } else {
      //For update
      user.transactionList[indexOfTransaction] = transaction;
      _transactionService.addAndUpdateuserTransactionsList(
          docId: user.userID,
          newTransactionList: user.getMappedTransactionList);
    }
  }
}
