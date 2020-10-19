import 'package:cloud_firestore/cloud_firestore.dart';

///Here a simple idea is the to save the date in the date on firestore
/// We thought before to save it in the cache memory but
/// It's can by hack very easly🌝,
///
/// So let us save is on firestore

//I'm so inspired for the name actually
//So excuse me for that
class MonthlyDate {
  //PDF fiel name to make easy if you want to change it later without have to find all the occurence of it
  final String PDF_NAME = 'dateWherePdfWillBeAvailable';

  CollectionReference _pdfDateReference =
      FirebaseFirestore.instance.collection('pdfDate');

  // Create a singleton class
  static MonthlyDate _monthlyDate = MonthlyDate._();

  //Internal construtor
  MonthlyDate._();

  //Get instance
  static get monthyDate => _monthlyDate;

  //Initialize the date for the first time
  intializeDate({String initialDate}) async {
    //The passed initialDate must be formatted like this m/d/y
    String _initialDate;
    if (initialDate != null) {
      _initialDate = initialDate;
    } else {
      //Date here the first date
      _initialDate =
          '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
      //Or we can add a dialog for that option
    }
    //Add it in the firestore
    await _pdfDateReference
        .doc(PDF_NAME)
        .set({'pdfDate': _initialDate, 'updated': 0});
  }

  //Update The pdfDate
  updateDate() async {
    DocumentSnapshot _docRef = await _pdfDateReference.doc(PDF_NAME).get();
    if (_docRef.exists) {
      Map<String, dynamic> _doc = _docRef.data();
      String _currentDate = _doc['pdfDate'];
      //Splitting of the date to increase the month for another date
      // The index 0 => month; index 1 => day; index 2 => year
      List<String> _splittedDate = _currentDate.split('/');
      if ((int.parse(_splittedDate[1]) == DateTime.now().month) &&
          (_doc['updated'] == 0)) {
        //If that condition is muched so will update the date where the pdf will be available
        _pdfDateReference.doc(PDF_NAME).update({
          'updated': 1,
          'pdfDate':
              '${int.parse(_splittedDate[0]) + 1}/${_splittedDate[1]}/${_splittedDate[2]}'
        });
        return null;
      }
    }
    //Reinistilasation
    intializeDate();
  }

  //TO get if we can view or not the pdf
  Future<bool> getPdfDate() async {
    DocumentSnapshot _docSnaphot = await _pdfDateReference.doc(PDF_NAME).get();
    String _actualDate =
        '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
    if (_actualDate == _docSnaphot.data()['pdfDate']) {
      return true;
    }
    return false;
  }
}
