import 'dart:convert';

import 'transaction.dart';

class User {
  String userID; //Represent the docID
  String name; // Here is store the nalme of the user
  String userCreationDate;
  List<Transaction> transactionList;

  User({name, transactionList}) {
    this.name = name;
    this.transactionList = transactionList;

    //Initialisation of the date
    userCreationDate = DateTime.now().toString();
    //Assertion chechings
    assert(name != null);
    assert(transactionList != null);
    assert(userCreationDate != null);
  }

  //Turn a user to map
  Map<String, dynamic> userToMap() => {
        'name': this.name,
        'created': this.userCreationDate.toString(),
        'transactionList': jsonEncode(this.transactionList)
      };

  //Calculate credit total amount
  double get calculateCreditAmount {
    double creditAmount = 0;

    //Calculation
    transactionList.forEach((Transaction transaction) {
      creditAmount += transaction.credit;
    });
    return creditAmount;
  }

  //Calculate debit total amount
  double get calculateDebitAmount {
    double debitAmount = 0;

    //Calculation
    transactionList.forEach((Transaction transaction) {
      debitAmount += transaction.debit;
    });
    return debitAmount;
  }

  //Calulate balance amount
  double get calculateBalanceAmount =>
      calculateCreditAmount - calculateDebitAmount;

  //Update transaction
  void updateTransactionList(
      {int index, double credit, double debit, String particular}) {
    transactionList[index].credit = credit;
    transactionList[index].debit = debit;
    transactionList[index].particular = particular;
  }

  //Turn Document SNaphot to User
  User.fromDocumentSnaphot(String docId, Map<String, dynamic> data) {
    this.userID = docId;
    this.name = data['name'];
    this.userCreationDate = data['created'];
    //Loop through data to create transaction List
    if(jsonDecode(data['transactionList']).length!=0){
      this.transactionList =
        jsonDecode(data['transactionList']).map((dynamic transaction) {
          print(transaction);
      return Transaction.mapToTransaction(transaction);
    });
    }
    else{
      this.transactionList =[];
    }
    }
  }
