//Show alert of the pdf
import 'package:flutter/material.dart';

showPDFAlert(value, BuildContext context) {
  print(value);
  if (value != true) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'PDF Not available actually',
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          content: Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.black54),
          ),
        ));
  }
}
