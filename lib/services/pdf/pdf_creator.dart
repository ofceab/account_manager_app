import 'dart:io';

import 'package:account_manager_app/models/user_transaction.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfCreator {
  static Future createOneUserRapport(User user) async {
    final pdf =
        pw.Document(author: 'Account Manager', creator: 'Account Manager');

    //add Page
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) {
          return [
            pw.Header(
                level: 0,
                child: pw.Text('Account Manager (${user.name})',
                    style: pw.TextStyle(fontSize: 35))),
            pw.Header(
                level: 2,
                child: pw.Table(children: [
                  pw.TableRow(children: [
                    pw.Text('Transaction Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Particular',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Credit',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Debit',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ])
                ])),
            pw.Table(
                children: user.transactionList.map((dynamic transaction) {
              return pw.TableRow(children: [
                pw.Text(transaction.transactionDate,
                    textAlign: pw.TextAlign.right),
                pw.Text(transaction.particular, textAlign: pw.TextAlign.right),
                pw.Text('${transaction.credit.toString()}',
                    textAlign: pw.TextAlign.right),
                pw.Text('${transaction.debit.toString()}',
                    textAlign: pw.TextAlign.right),
              ]);
            }).toList()),
            pw.Footer(
                title: pw.Header(
                    margin: pw.EdgeInsets.only(top: 15),
                    level: 2,
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              'Credit Total Amount: ${_calculateCreditTotal(user)['credit']}',
                              textAlign: pw.TextAlign.left,
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                              'Debit Total Amount: ${_calculateCreditTotal(user)['debit']}',
                              textAlign: pw.TextAlign.left,
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(
                              'Balance Total Amount: ${_calculateCreditTotal(user)['balance']}',
                              textAlign: pw.TextAlign.left,
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ])))
          ];
        }));
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String path = '$directory/account-${user.name}.pdf';
    final File file = File(path);
    file.writeAsBytes(pdf.save());
    //Open the PDF document in mobile
    OpenFile.open(path);
  }

  static Future createAllUsersRapports(List<User> users) async {
    final pdf =
        pw.Document(author: 'Account Manager', creator: 'Account Manager');

    //add Page
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) {
          return _buildFullList(users);
        }));

    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String path = '$directory/account-full-report.pdf';
    final File file = File(path);
    file.writeAsBytes(pdf.save());
    //Open the PDF document in mobile
    OpenFile.open(path);
  }

  ///For calculation purpose
  static Map<String, double> _calculateCreditTotal(User user) {
    double _creditTotalAmount = 0;
    double _balanceTotalAmount = 0;
    double _debitTotalAmount = 0;
    user.transactionList.forEach((dynamic transaction) {
      _creditTotalAmount += transaction.credit;
      _debitTotalAmount += transaction.debit;
      _balanceTotalAmount += (transaction.credit - transaction.debit);
    });

    return {
      'credit': _creditTotalAmount,
      'debit': _debitTotalAmount,
      'balance': _balanceTotalAmount,
    };
  }

  //Build Full List Widget
  static _buildFullList(List<User> users) {
    return users.map((User user) {
      pw.Column(children: [
        pw.Header(level: 2, child: pw.Text(user.name)),
        pw.Header(
            level: 2,
            child: pw.Table(children: [
              pw.TableRow(children: [
                pw.Text('Transaction Date',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Particular',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Credit',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Debit',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ])
            ])),
        pw.Table(
            tableWidth: pw.TableWidth.max,
            children: user.transactionList.map((dynamic transaction) {
              return pw.TableRow(children: [
                pw.Text(transaction.transactionDate,
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(transaction.particular,
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${transaction.credit.toString()}',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${transaction.debit.toString()}',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ]);
            }).toList()),
        pw.Header(
            margin: pw.EdgeInsets.only(top: 15),
            level: 2,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                      'Credit Total Amount: ${_calculateCreditTotal(user)['credit']}',
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      'Debit Total Amount: ${_calculateCreditTotal(user)['debit']}',
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      'Balance Total Amount: ${_calculateCreditTotal(user)['balance']}',
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]))
      ]);
    }).toList();
  }
}
