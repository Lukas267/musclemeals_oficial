import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_ingredient.dart';
import 'package:muscel_meals/custom_widgets/custom_single_tracking_widget.dart';

class CustomTrackingWidget extends StatefulWidget {
  final int kcal;
  final int protein;
  final int fat;
  final int carbohydrates;

  const CustomTrackingWidget(
      {required this.kcal,
      required this.protein,
      required this.fat,
      required this.carbohydrates,
      Key? key})
      : super(key: key);

  @override
  State<CustomTrackingWidget> createState() => _CustomTrackingWidgetState();
}

class _CustomTrackingWidgetState extends State<CustomTrackingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'Nährstoffe',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              const VerticalDivider(
                width: 0,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomSingleTrackingWidget(
                        text: 'Kalorien: ${widget.kcal}',
                      ),
                    ),
                    const Divider(
                      height: 0,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomSingleTrackingWidget(
                        text: 'Fette: ${widget.fat}',
                      ),
                    ),
                    const Divider(
                      height: 0,
                    )
                  ],
                ),
              ),
              const VerticalDivider(
                width: 0,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    Expanded(
                        flex: 1,
                        child: CustomSingleTrackingWidget(
                            text: 'Proteine: ${widget.protein}')),
                    const Divider(
                      height: 0,
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomSingleTrackingWidget(
                        text: 'Kohlenhydrate: ${widget.carbohydrates}',
                      ),
                    ),
                    const Divider(
                      height: 0,
                    ),
                  ],
                ),
              ),
              const VerticalDivider(
                width: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
