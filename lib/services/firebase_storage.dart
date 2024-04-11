import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> getDownloadURL(url) async {
    try {
      var a = await FirebaseStorage.instance
          .ref()
          .child('/bowl_pictures/$url')
          .getDownloadURL();
      return a;
    } catch (e) {
      return e.toString();
    }
  }
}
