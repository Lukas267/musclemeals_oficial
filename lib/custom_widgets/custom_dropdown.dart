import 'package:flutter/material.dart';
import 'package:muscel_meals/services/input-field-validation_service.dart';
import 'package:provider/provider.dart';

class CustomDropdown extends StatefulWidget {
  final List items;
  final ValueChanged valueChanged;
  dynamic locationError;

  CustomDropdown(this.valueChanged, this.items, this.locationError, {Key? key})
      : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.location_on),
        border: const OutlineInputBorder(),
        errorText: widget.locationError,
      ),
      hint: const Text('Select Location'),
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
    );
  }
}

class Value extends ChangeNotifier {
  String? value;

  void changeValue(String newValue) {
    value = newValue;
    notifyListeners();
  }
}
