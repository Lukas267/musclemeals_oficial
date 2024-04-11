import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_button.dart';
import 'package:muscel_meals/custom_widgets/custom_dialog.dart';
import 'package:muscel_meals/custom_widgets/custom_ingredient.dart';
import 'package:muscel_meals/custom_widgets/custom_tracking_widget.dart';
import 'package:muscel_meals/custom_widgets/ingredients_widget.dart';
import 'package:muscel_meals/pages/bowl-summary_page.dart';
import 'package:muscel_meals/pages/home_page.dart';
import 'package:muscel_meals/pages/old-order_page.dart';
import 'package:muscel_meals/services/firebase-database_service.dart';
import 'package:provider/provider.dart';

class CustomizeBowl extends StatefulWidget {
  final Map bowlIngredients;

  const CustomizeBowl({required this.bowlIngredients, Key? key})
      : super(key: key);

  @override
  State<CustomizeBowl> createState() => _CustomizeBowlState();
}

class _CustomizeBowlState extends State<CustomizeBowl> {
  int gram = 0;
  int protein = 0;
  int kcal = 0;
  int fat = 0;
  int carbohydrates = 0;
  double price = 0.00;

  bool calculated = false;

  List ingredients = [
    {'category': 'bases', 'ingredients': {}}
  ];

  void changeGram(int input, String name, String category) {
    widget.bowlIngredients['ases'][name] = input;
  }

  void deleteNullValues() {
    widget.bowlIngredients.keys.forEach(
      (category) {
        widget.bowlIngredients[category]
            .removeWhere((key, value) => value == 0);
      },
    );
  }

  void calculateNutritionalValues(
      Map<String, dynamic> ingredient, double quantity) {
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
      protein = 0;
      kcal = 0;
      fat = 0;
      carbohydrates = 0;
      price = 0.0;

      widget.bowlIngredients.forEach((category, ingredients) {
        snapshot.where((s) => s['category'] == category).forEach((item) {
          item['ingredients'].forEach((ingredient) {
            if (ingredients.containsKey(ingredient['name'])) {
              double quantity =
                  double.parse(ingredients[ingredient['name']].toString());
              calculateNutritionalValues(ingredient, quantity);
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
    print(widget.bowlIngredients);
    var snap = await DatabaseService().getIngredients();
    snap.forEach((s) => widget.bowlIngredients[s['category']] ??= {});

    changeValues(snap);
    setState(() => calculated = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bowl zusammenstellen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          calculated == false
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomTrackingWidget(
                      kcal: kcal,
                      protein: protein,
                      fat: fat,
                      carbohydrates: carbohydrates),
                ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Divider(
              thickness: 3,
              height: 60,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Zutaten',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: DatabaseService().getIngredients(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title: Text(
                                      snapshot.data![index]['category'],
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    children: [
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot
                                            .data![index]['ingredients'].length,
                                        itemBuilder:
                                            (context, ingredientIndex) {
                                          return CustomIngredientWidget(
                                            ingredient: snapshot.data![index]
                                                    ['ingredients']
                                                [ingredientIndex],
                                            bowlIngredients:
                                                widget.bowlIngredients,
                                            category: snapshot.data![index]
                                                ['category'],
                                            onChanged: () async {
                                              deleteNullValues();
                                              changeValues(snapshot.data!);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error'),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*
          FutureWidget(
            category: 'bases',
            bowlIngredients: widget.bowlIngredients,
            future: DatabaseService().getBases(),
            prepared: widget.bowlIngredients,
            valueChanged: () async {
              deleteNullValues();
              changeValues(await DatabaseService().getBases());
            },
          ),
          */
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Preis: ${price.toStringAsFixed(2)}€',
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 12,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (route) => false);
                          },
                          child: const Text('Abbrechen'),
                        ),
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 12,
                      child: OutlinedButton(
                        child: const Text('Speichern'),
                        onPressed: () {
                          bool isEmpty = true;
                          widget.bowlIngredients.keys.forEach((element) {
                            if (widget.bowlIngredients[element].isNotEmpty) {
                              isEmpty = false;
                            }
                          });
                          if (isEmpty == false) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BowlSummary(
                                  bowlIngredients: widget.bowlIngredients,
                                  price: price,
                                  kcal: kcal,
                                  protein: protein,
                                  fat: fat,
                                  carbohydrates: carbohydrates,
                                ),
                              ),
                            );
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog.CustomDialog('Error',
                                    'Du musst mindestens eine Zutat auswählen.');
                              },
                            );
                          }
                          /*
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BowlSummary(
                                    bowlIngredients: widget.bowlIngredients,
                                    price: price,
                                  )));
                                  */
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Values extends ChangeNotifier {}

class BowlNotifier extends ChangeNotifier {
  List bowl = [];
  void changeValue(List newValue) {
    bowl = newValue;
    notifyListeners();
  }

  void clearList() {
    bowl.clear();
    notifyListeners();
  }
}
