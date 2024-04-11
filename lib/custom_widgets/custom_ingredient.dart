import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muscel_meals/ingredient.dart';

class CustomIngredientWidget extends StatefulWidget {
  final Map ingredient;
  final Map bowlIngredients;
  final String category;
  final Function onChanged;

  const CustomIngredientWidget(
      {required this.ingredient,
      required this.bowlIngredients,
      required this.category,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  State<CustomIngredientWidget> createState() => _CustomIngredientWidgetState();
}

class _CustomIngredientWidgetState extends State<CustomIngredientWidget> {
  double value = 0;

  void prepare() {
    widget.bowlIngredients.keys.forEach((category) {
      widget.bowlIngredients[category].keys.forEach((ingredient) {
        if (ingredient == widget.ingredient['name']) {
          value =
              int.parse(widget.bowlIngredients[category][ingredient].toString())
                  .toDouble();
        }
      });
    });
    //print(widget.ingredient);
    //widget.bowlIngredients[widget.category].keys.forEach(
    //(element) {
    /*
        if (element == widget.ingredient['name']) {
          print(element);
          value = int.parse(
                widget.bowlIngredients[widget.category][element].toString())
          .toDouble();
        }
        */
    //},
    //);
  }

  @override
  void initState() {
    prepare();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.ingredient['name'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${value}g',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        children: [
          Slider(
            value: value,
            max: 300,
            divisions: 300,
            onChanged: (input) {
              setState(() {
                value = input.roundToDouble();
                widget.bowlIngredients[widget.category]
                    [widget.ingredient['name']] = value.toDouble();
                widget.onChanged();
              });
            },
          ),
        ],
      ),
    );
  }
}
