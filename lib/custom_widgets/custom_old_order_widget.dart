import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscel_meals/pages/old-order_page.dart';

import '../pages/bowl-summary_page.dart';
import '../services/firebase-database_service.dart';

class CustomOrderWidget extends StatefulWidget {
  final Map order;

  const CustomOrderWidget({required this.order, super.key});

  @override
  State<CustomOrderWidget> createState() => _CustomOrderWidgetState();
}

class _CustomOrderWidgetState extends State<CustomOrderWidget> {
  int protein = 0;
  int kcal = 0;
  int fat = 0;
  int carbohydrates = 0;
  double price = 0;
  late Map bowlIngredients;
  late List categories;
  Map sortedCategories = {};

  void calculateNutritionalValues(
      Map<String, dynamic> ingredient, String key, double quantity) {
    protein +=
        (quantity * double.parse(ingredient['protein'].toString())).toInt();
    kcal += (quantity * double.parse(ingredient['kcal'].toString())).toInt();
    fat += (quantity * double.parse(ingredient['fat'].toString())).toInt();
    carbohydrates +=
        (quantity * double.parse(ingredient['carbohydrates'].toString()))
            .toInt();
    price += quantity * double.parse(ingredient['price'].toString());
  }

  void changeValues(List snapshot) {
    setState(() {
      protein = kcal = fat = carbohydrates = 0;
      price = 0.0;
      bowlIngredients.forEach((category, ingredients) {
        snapshot.where((s) => s['category'] == category).forEach((item) {
          item['ingredients'].forEach((ingredient) {
            if (ingredients.containsKey(ingredient['name'])) {
              calculateNutritionalValues(ingredient, ingredient['name'],
                  double.parse(ingredients[ingredient['name']].toString()));
            }
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeIngredients();
  }

  Future<void> initializeIngredients() async {
    bowlIngredients = widget.order['ingredients'];
    var snap = await DatabaseService().getIngredients();
    snap.forEach((s) => bowlIngredients[s['category']] ??= {});

    changeValues(snap);
    categories = await DatabaseService().getCategories();

    sortedCategories = Map.fromIterables(
        categories,
        categories
            .map((c) => bowlIngredients[c] ?? {})
            .where((e) => e.isNotEmpty));

    print(bowlIngredients);
    print(sortedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderPage(
              timestamp: widget.order['pickUpTimestamp'],
              price: widget.order['price'],
              kcal: widget.order['kcal'],
              protein: widget.order['protein'],
              fat: widget.order['fat'],
              carbs: widget.order['carbohydrates'],
              bowlIngredients: sortedCategories,
              location: widget.order['location'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.date_range),
                    Text(' Datum:'),
                  ],
                ),
                Text(
                  DateFormat('dd.MM.yyyy').format(
                    widget.order['pickUpTimestamp'].toDate(),
                  ),
                ),
              ],
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.schedule),
                    Text(' Abhohlzeit:'),
                  ],
                ),
                Text('${DateFormat('HH:mm').format(
                  widget.order['pickUpTimestamp'].toDate(),
                )}Uhr'),
              ],
            ),
            const Divider(),
            Text(
              widget.order['complete'] == false ? 'In Arbeit' : 'Fertig',
            ),
          ],
        ),
      ),
    );
  }
}
