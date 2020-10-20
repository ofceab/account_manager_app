import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

///Here a simple idea is the to save the date in the date on firestore
/// We thought before to save it in the cache memory but
/// It's can by hack very easly🌝,
///
/// So let us save is on firestore

//I'm so inspired for the name actually
//So excuse me for that
class MonthlyDate {
  //PDF fiel name to make easy if you want to change it later without have to find all the occurence of it
  final String pdfDocID = 'dateWherePdfWillBeAvailable';

  CollectionReference _pdfDateReference =
      FirebaseFirestore.instance.collection('pdfMonthlyCollection');

  // Create a singleton class
  static MonthlyDate _monthlyDate = MonthlyDate._();

  //Internal construtor
  MonthlyDate._();

  //Get instance
  static get monthyDate => _monthlyDate;

  //Initialize the date for the first time
  Future intializeDate({String initialDate}) async {
    //The passed initialDate must be formatted like this m/d/y
    String _initialDate;
    if (initialDate != null) {
      _initialDate = initialDate;
    } else {
      //here the first date
      //the first date will be 1/0

      _initialDate =
          '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
      //Or we can add a dialog for that option
    }
    //Add it in the firestore
    DocumentSnapshot _docRef = await _pdfDateReference.doc(pdfDocID).get();
    if (!_docRef.exists) {
      await _pdfDateReference
          .doc(pdfDocID)
          .set({'pdfDate': _initialDate, 'updated': 0}).then(
              (value) => print('Ready to go'));
    }

    //else nothing
  }

  //Update The pdfDate
  updateDate() async {
    print('Running');
    DocumentSnapshot _docRef = await _pdfDateReference.doc(pdfDocID).get();
    if (_docRef.exists) {
      print('Existed');
      Map<String, dynamic> _doc = _docRef.data();
      String _currentDate = _doc['pdfDate'];
      //Splitting of the date to increase the month for another date
      // The index 0 => month; index 1 => day; index 2 => year
      List<String> _splittedDate = _currentDate.split('/');

      if ((int.parse(_splittedDate[1]) == DateTime.now().day) &&
          //The pdf will be available during one day so till 00:00
          (TimeOfDay.now().hour <= 23 && TimeOfDay.now().minute <= 59)) {
        //If that condition is muched so will update the date where the pdf will be available
        print('Good time');
        //CHeck now if the date has already been update
        if (int.parse(_splittedDate[0]) == DateTime.now().month) {
          //If right so the date has been update yet
          print('Right date');
          _pdfDateReference.doc(pdfDocID).update({
            'pdfDate':
                '${int.parse(_splittedDate[0]) + 1}/${_splittedDate[1]}/${_splittedDate[2]}'
          });
        }
        // else it has already been updated
      }
    }
    //Reinistilasation
    intializeDate();
  }

  //TO get if we can view or not the pdf
  Future<dynamic> getPdfDate() async {
    DocumentSnapshot _docSnaphot = await _pdfDateReference.doc(pdfDocID).get();
    String _actualDate =
        '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
    if (_actualDate == _docSnaphot.data()['pdfDate']) {
      return true;
    }
    return 'The pdf will be available on the ${_docSnaphot.data()['pdfDate']} \nThanks.';
  }
}
