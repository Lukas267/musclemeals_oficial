import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../services/firebase-database_service.dart';

class CustomDialogQRCode extends StatefulWidget {
  const CustomDialogQRCode({Key? key}) : super(key: key);

  @override
  State<CustomDialogQRCode> createState() => _CustomDialogQRCodeState();
}

class _CustomDialogQRCodeState extends State<CustomDialogQRCode> {
  dynamic name;

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  void getUserName() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      name = documentSnapshot.get('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: name == null
          ? Container(
              height: 0,
            )
          : Center(
              //child: CustomFutureTextBuilder(DatabaseService().getUserName()),
              ),
      content: SingleChildScrollView(
        child: SfBarcodeGenerator(
          value: FirebaseAuth.instance.currentUser!.uid,
          symbology: QRCode(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Done',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    ;
  }
}
