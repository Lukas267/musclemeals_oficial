import 'package:flutter/material.dart';

class CustomSingleTrackingWidget extends StatefulWidget {
  final String text;

  const CustomSingleTrackingWidget({required this.text, super.key});

  @override
  State<CustomSingleTrackingWidget> createState() =>
      _CustomSingleTrackingWidgetState();
}

class _CustomSingleTrackingWidgetState
    extends State<CustomSingleTrackingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: FittedBox(
              child: Text(
                widget.text,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
