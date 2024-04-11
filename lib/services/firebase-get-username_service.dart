import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {

  Future<String> getUserName() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(
        'users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String name = documentSnapshot.get('name').toString();
    return name;
  }

}