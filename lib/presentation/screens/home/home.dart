import 'package:account_manager_app/helpers/appTheme.dart';
import 'package:account_manager_app/models/user_transaction.dart';
import 'package:account_manager_app/presentation/screens/error/error.dart';
import 'package:account_manager_app/presentation/screens/loading/loading.dart';
import 'package:account_manager_app/presentation/widgets/transaction_list_item.dart';
import 'package:account_manager_app/presentation/widgets/user_create_alert.dart';
import 'package:account_manager_app/services/transaction_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  //Get our singleton firebaseService object
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Dashboard'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(context),
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Create a user',
      ),
        body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.generalOutSpacing-10,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: _transactionService.fetchAllUsersTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Error();
                else if (snapshot.hasData) {
                  //Get documents
                  List<QueryDocumentSnapshot> _docs = snapshot.data.docs;
                  if (snapshot.data.size == 0) {
                    return Center(child: Text('No User yet'));
                  }

                  //Instead retuning the listView itself
                  return ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (context, index) {
                      User user = User.fromDocumentSnaphot(
                          _docs[index].id, _docs[index].data());
                      return TransactionListItem(user: user);
                    },
                  );
                }

                //Loading
                return Loading();
              },
            )));
  }

  _showDialog(BuildContext context) {
    showDialog(context: context, child: UserCreateAlert());
  }
}
