import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.btnTxt,
  }) : super(key: key);
  final String title, body, btnTxt;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(body),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(btnTxt),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
