import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

mixin TransactionHelpers {
  //Getting transaction reference
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection('transactions');

  //Create a user
  Future<void> createAUser({@required Map<String, dynamic> userData}) {
    assert(userData != null);
    try {
      _transactions.add(userData);
    return null;
    } catch (e) {
      rethrow;
    }
  }

  //Delete a user
  Future<void> deleteAUser({@required String docId}) {
    assert(docId != null);
    try {
      _transactions.doc(docId).delete();
    return null;
    } catch (e) {
      rethrow;
    }
  }

  //Update  and add userTransaction
  Future<String> addAndUpdateuserTransactionsList(
      {@required String docId,
      @required String newTransactionList,
      @required String operationType}) async {
    //Assertion chechings
    assert(docId != null);
    assert(newTransactionList != null);
    assert(operationType != null);
    try {
      await _transactions
          .doc(docId)
          .update({'transactionList': newTransactionList});
      return operationType == 'add'
          ? 'Transaction has been added'
          : 'Transaction has be edited';
    } on FirebaseException catch (e) {
      print(e.message);
      return 'An error Occured, sure of your connection';
    } catch (e) {
      return 'An internal error occured';
    }
  }

  //Get all usersTransaction
  Stream<QuerySnapshot> fetchAllUsersTransaction()=>
       _transactions.snapshots(includeMetadataChanges: true);
}
