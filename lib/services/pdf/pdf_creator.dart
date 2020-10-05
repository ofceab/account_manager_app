import 'package:account_manager_app/models/user_transaction.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfCreator {
  static createOneUserRapport(User user) {
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
                child: pw.Text(user.name, style: pw.TextStyle(fontSize: 35))),

            //   pw.Table(children: [pw.TableRow(
            //       children:
            //   )])
          ];
        }));
  }
}
