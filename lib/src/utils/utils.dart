import 'package:flutter/material.dart';

bool isNumber(String? s) {
  if (s!.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

String? isEmpyProducto(String? s) {
  if (s!.isEmpty) {
    return null;
  } else {
    return s;
  }
}

alertDialog(BuildContext context, String messageErro) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Done'),
          content: Text(messageErro),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
