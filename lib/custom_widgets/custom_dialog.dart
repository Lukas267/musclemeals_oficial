import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {

  final String titel;
  final String errorText;

  const CustomDialog.CustomDialog(
      @required this.titel,
      @required this.errorText,
      {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titel),
      content: SingleChildScrollView(
        child: Text(errorText)
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
