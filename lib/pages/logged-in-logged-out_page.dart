import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscel_meals/pages/home_page.dart';
import 'package:muscel_meals/pages/login_page.dart';
import 'package:muscel_meals/pages/register_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return const Home();
        } else {
          return const SignIn();
        }
      },
    );
  }
}
