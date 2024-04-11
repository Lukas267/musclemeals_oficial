import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_button.dart';
import 'package:muscel_meals/custom_widgets/custom_dialog.dart';
import 'package:muscel_meals/custom_widgets/custom_text_field.dart';
import 'package:muscel_meals/pages/register_page.dart';
import 'package:muscel_meals/services/firebase-auth_service.dart';
import 'package:muscel_meals/services/input-field-validation_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _userEMailController = TextEditingController();
  final _userPasswordController = TextEditingController();

  bool isLoading = false;
  bool isTextObscure = true;
  Icon visibility = const Icon(Icons.visibility_off);

  dynamic authResult;

  dynamic emailError;
  dynamic passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Muscle Meals')),
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
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        SizedBox(
                          width: 400,
                          height: 50,
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                                authResult = null;
                                emailError = Validator()
                                    .emailValidation(_userEMailController.text);
                                passwordError = Validator().passwordValidation(
                                    _userPasswordController.text);
                              });
                              if (emailError == null && passwordError == null) {
                                authResult = await AuthService()
                                    .signInWithEmailAndPassword(
                                  _userEMailController.text,
                                  _userPasswordController.text,
                                );
                              }
                              if (authResult != null) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog.CustomDialog(
                                          'Error', authResult);
                                    });
                              }
                              setState(() {});

                              if (AuthService().isUserSignedIn()) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'MainPage', (route) => false);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: const Text('Anmelden'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Du hast noch keinen Account?'),
                            const Text(' '),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'SignUp', (route) => false);
                              },
                              child: const Text(
                                'Registrieren',
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
