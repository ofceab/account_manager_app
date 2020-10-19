import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

mixin TransactionHelpers {
  //Getting transaction reference
  final CollectionReference _transactions =
      FirebaseFirestore.instance.collection('transactions');

  //Getting transaction reference
  final CollectionReference _deletedUsers =
      FirebaseFirestore.instance.collection('deletedUsers');

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
  Future<void> deleteAUser({@required String docId, bool onDeleted}) async {
    assert(docId != null);
    try {
      if (onDeleted) {
        //here we delete the user fom the deleteUsers collection
        //Here getting user data
        _deletedUsers.doc(docId).delete();
        return null;
      }

      //here we delete the user fom the transaction collection

      //Here getting user data
      final DocumentSnapshot _userData = await _transactions.doc(docId).get();
      _transactions.doc(docId).delete();
      _deletedUsers.doc(docId).set(_userData.data());
      return null;
    } catch (e) {
      rethrow;
    }
  }

  ///Update  and add userTransaction
  ///{dynamic} here stand for Map<String, dynamic>
  Future<String> addAndUpdateuserTransactionsList(
      {@required String docId,
      @required List<dynamic> newTransactionList,
      String operationType: 'add'}) async {
    //Assertion chechings
    assert(docId != null);
    assert(newTransactionList != null);
    assert(operationType != null);
    try {
      await _transactions
          .doc(docId)
          .update({'transactionList': newTransactionList});
      final DocumentSnapshot _userData = await _deletedUsers.doc(docId).get();
      _deletedUsers.doc(docId).set(_userData.data());

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
  Stream<QuerySnapshot> fetchAllUsersTransaction({String userID}) =>
      _transactions.snapshots(includeMetadataChanges: true);

  //Get all deleted users
  Stream<QuerySnapshot> fetchAllUsersDeletedTransaction({String userID}) =>
      _deletedUsers.snapshots(includeMetadataChanges: true);

  //Get one userTransaction
  Stream<DocumentSnapshot> fetchOneUsersTransaction(
          {@required String userID}) =>
      _transactions.doc(userID).snapshots(includeMetadataChanges: true);
}
