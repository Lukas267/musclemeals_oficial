import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatefulWidget {
  final List items;
  final dynamic errorText;
  dynamic value;
  final ValueChanged valueChanged;

  CustomDropdownWidget(
      {required this.items,
      required this.errorText,
      required this.value,
      required this.valueChanged,
      Key? key})
      : super(key: key);

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.location_on),
            border: const OutlineInputBorder(),
            errorText: widget.errorText,
          ),
          hint: const Text('Standort auswählen'),
          isExpanded: true,
          items: widget.items.map(
            (e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e),
              );
            },
          ).toList(),
          onChanged: widget.valueChanged,
        ),
      ),
    );
  }
}
