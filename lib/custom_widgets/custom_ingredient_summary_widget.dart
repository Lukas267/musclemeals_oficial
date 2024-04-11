import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_single_tracking_widget.dart';

import '../services/firebase-database_service.dart';

class BowlSummaryWidget extends StatefulWidget {
  final Map bowlIngredients;
  final double price;

  const BowlSummaryWidget(
      {required this.bowlIngredients, required this.price, super.key});

  @override
  State<BowlSummaryWidget> createState() => _BowlSummaryWidgetState();
}

class _BowlSummaryWidgetState extends State<BowlSummaryWidget> {
  List ingredients = [];
  late List categories;
  Map sortedCategories = {};

  void mapToList() {
    sortedCategories.keys.forEach((category) {
      if (sortedCategories[category].isNotEmpty) {
        print(category);
        ingredients.add({
          'category': category,
          'ingredients': [],
        });
        sortedCategories[category].keys.forEach((ingredient) {
          ingredients.last['ingredients'].add({
            'name': ingredient,
            'gram': sortedCategories[category][ingredient],
          });
        });
      }
    });
    print('b');
    print(ingredients);
  }

  @override
  void initState() {
    //mapToList();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      categories = await DatabaseService().getCategories();
      for (int i = 0; i < categories.length; i++) {
        widget.bowlIngredients.keys.forEach(
          (element) {
            if (element == categories[i]) {
              sortedCategories[element] = widget.bowlIngredients[element];
            }
          },
        );
      }
      print('A');
      print(sortedCategories);
      mapToList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Zutaten',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Divider(
          height: 0,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const VerticalDivider(
                        width: 0,
                      ),
                      Text(
                        ingredients[index]['category'],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const VerticalDivider(
                        width: 0,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ingredients[index]['ingredients'].length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const VerticalDivider(
                                  width: 0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CustomSingleTrackingWidget(
                                    text: ingredients[index]['ingredients'][i]
                                        ['name'],
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CustomSingleTrackingWidget(
                                    text:
                                        '${ingredients[index]['ingredients'][i]['gram'].toString()}g',
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 0,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      );
                    })
              ],
            );
          },
        ),
        const Divider(),
        Text('${widget.price.toStringAsFixed(2)}€'),
      ],
    );
  }
}
