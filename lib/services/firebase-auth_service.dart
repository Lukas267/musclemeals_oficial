
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:muscel_meals/pages/home_page.dart';
import 'package:muscel_meals/pages/login_page.dart';
import 'package:muscel_meals/pages/logged-in-logged-out_page.dart';
import 'package:muscel_meals/services/firebase-database_service.dart';
import 'package:muscel_meals/services/input-field-validation_service.dart';
import 'package:flutter/material.dart';

class AuthService {

  //checks if user is logged in
  bool isUserSignedIn() {
    return FirebaseAuth.instance.currentUser != null ? true : false;
  }

  //sign in Anonymously
  Future signInAnonymously() async{
    try {
      final userCredential =
        await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  //sign up with E-Mail & Password
  Future registerWithEmailAndPassword(String emailAddress, String password, String name) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      DatabaseService().addUserInformation(name);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign in with E-Mail & Password
  Future signInWithEmailAndPassword(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign out
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

}