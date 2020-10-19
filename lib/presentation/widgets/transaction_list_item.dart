import 'package:account_manager_app/helpers/appTheme.dart';
import 'package:account_manager_app/models/user_transaction.dart';
import 'package:account_manager_app/presentation/screens/details/details_list.dart';
import 'package:account_manager_app/services/transaction_services.dart';
import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  final bool deleted;
  final User user;
  final TransactionService _transactionService =
      TransactionService.getTransactionServiceInstance;

  TransactionListItem({@required this.user, this.deleted: false})
      : assert(user != null);

  @override
  Widget build(BuildContext context) {
    print(user.transactionList);
    return GestureDetector(
      onTap: () => (!this.deleted) ? _pushToDetailsScreen(context) : null,
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: AppTheme.generalOutSpacing),
        padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.generalOutSpacing - 15),
        height: AppTheme.listItemHeight,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                      '${user.name[0].toUpperCase()}${user.name.substring(1)}',
                      style: AppTheme.userStyle
                          .copyWith(color: Colors.blue.shade300)),
                ),
                IconButton(
                  onPressed: _deleteUserHandler,
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                )
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  _buildCustomContainer(
                      'Credit',
                      user.calculateCreditAmount.toString(),
                      AppTheme.creditColor),
                  _buildCustomContainer(
                      'Debit',
                      user.calculateDebitAmount.toString(),
                      AppTheme.debitColor),
                  _buildCustomContainer('Balance',
                      user.calculateBalanceAmount.toString(), Colors.blue[100]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Build container
  Expanded _buildCustomContainer(
      String nameOfField, String amount, Color color) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 7, color: color, offset: Offset(1.1, 3.3))
      ], borderRadius: BorderRadius.circular(15), color: color),
      margin: const EdgeInsets.only(
          left: AppTheme.smallSpacing - 2,
          right: AppTheme.smallSpacing - 2,
          bottom: (AppTheme.smallSpacing + 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(nameOfField, style: AppTheme.generalTextStyle),
          Text('$amount €', style: AppTheme.generalTextStyle),
        ],
      ),
    ));
  }

  //Handler to delete user;
  Future _deleteUserHandler() async {
    if (this.deleted) {
      await _transactionService.deleteAUser(
          docId: user.userID, onDeleted: true);
      return null;
    }
    await _transactionService.deleteAUser(
        docId: user.userID, onDeleted: this.deleted);
  }

  //Push to another screen(the details screen)
  void _pushToDetailsScreen(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => DetailsList(user: user)));
}
