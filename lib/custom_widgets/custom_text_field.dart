import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {

  final String hintText;
  final TextEditingController controller;
  final Icon prefixIcon;
  dynamic errorText;
  final bool obscureText;
  final TextInputType textInputType;
  bool isPasswordTextField;

  CustomTextField({
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    required this.errorText,
    required this.obscureText,
    required this.textInputType,
    required this.isPasswordTextField,
    Key? key}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isTextObscure = true;
  Icon visibility = const Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {

    dynamic isPasswordTextField() {
      if (widget.isPasswordTextField == true) {
        return InkWell(
          onTap: () {
            setState(() {
              if (isTextObscure) {
                isTextObscure = false;
                visibility = const Icon(Icons.visibility);
              } else {
                isTextObscure = true;
                visibility = const Icon(Icons.visibility_off);
              }
            });
          },
          child: visibility,
        );
      }
    }

    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPasswordTextField ? isTextObscure : false,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: isPasswordTextField(),
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          errorText: widget.errorText,
        ),
      ),
    );
  }
}



