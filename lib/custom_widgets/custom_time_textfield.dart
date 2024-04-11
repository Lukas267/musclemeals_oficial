import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTimeTextField extends StatefulWidget {
  final int value;
  final ValueChanged valueChanged;
  final TextAlign textAlign;

  const CustomTimeTextField(
      {required this.value,
      required this.valueChanged,
      required this.textAlign,
      Key? key})
      : super(key: key);

  @override
  State<CustomTimeTextField> createState() => _CustomTimeTextFieldState();
}

class _CustomTimeTextFieldState extends State<CustomTimeTextField> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.grey,
        child: TextFormField(
          initialValue: widget.value.toString(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: widget.valueChanged,
        ),
      ),
    );
  }
}
