import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_button.dart';
import 'package:muscel_meals/custom_widgets/custom_dropdown.dart';
import 'package:muscel_meals/custom_widgets/custom_text_field.dart';
import 'package:muscel_meals/services/firebase-auth_service.dart';
import 'package:muscel_meals/services/firebase-database_service.dart';
import 'package:muscel_meals/services/input-field-validation_service.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/custom_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _userEMailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userNameController = TextEditingController();

  bool _isLoading = false;
  bool isTextObscure = true;
  Icon visibility = const Icon(Icons.visibility_off);

  dynamic authResult;

  dynamic nameError;
  dynamic emailError;
  dynamic passwordError;

  dynamic dropdownValue;

  void fillErrors() {
    nameError = Validator().nameValidation(_userNameController.text);
    emailError = Validator().emailValidation(_userEMailController.text);
    passwordError =
        Validator().passwordValidation(_userPasswordController.text);
  }

  Future<dynamic> registerUser() async {
    if (nameError == null && emailError == null && passwordError == null) {
      return await AuthService().registerWithEmailAndPassword(
        _userEMailController.text,
        _userPasswordController.text,
        _userNameController.text,
      );
    }
  }

  dynamic authErrorHandler(context) {
    if (authResult != null) {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog.CustomDialog('Error', authResult);
        },
      );
    }
  }

  void goToMainPage() {
    if (AuthService().isUserSignedIn()) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('MainPage', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue = Provider.of<Value>(context).value;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Muscle Meals'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 50,
              ),
              //Name Text Field
              CustomTextField(
                hintText: 'Name',
                controller: _userNameController,
                prefixIcon: const Icon(Icons.person),
                errorText: nameError,
                obscureText: false,
                textInputType: TextInputType.name,
                isPasswordTextField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              //E-Mail Text Field
              CustomTextField(
                hintText: 'E-Mail',
                controller: _userEMailController,
                prefixIcon: const Icon(Icons.email),
                errorText: emailError,
                obscureText: false,
                textInputType: TextInputType.emailAddress,
                isPasswordTextField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              //Password Text Field
              CustomTextField(
                hintText: 'Passwort',
                controller: _userPasswordController,
                prefixIcon: const Icon(Icons.key),
                errorText: passwordError,
                obscureText: isTextObscure,
                textInputType: TextInputType.text,
                isPasswordTextField: true,
              ),
              const SizedBox(
                height: 10,
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 400,
                          height: 50,
                          child: TextButton(
                            onPressed: () async {
                              authResult = null;
                              setState(() {
                                _isLoading = true;
                                fillErrors();
                              });
                              authResult = await registerUser();
                              authErrorHandler(context);
                              goToMainPage();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: const Text('Registrieren'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Du hast schon einen Account?'),
                            const Text(' '),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'SignIn', (route) => false);
                              },
                              child: const Text(
                                'Anmelden.',
                                style: TextStyle(color: Colors.orange),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
