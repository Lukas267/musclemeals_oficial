import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:muscel_meals/custom_widgets/custom_dropdown.dart';
import 'package:muscel_meals/custom_widgets/custom_ingredient_summary_widget.dart';
import 'package:muscel_meals/custom_widgets/custom_time_textfield.dart';
import 'package:muscel_meals/custom_widgets/custom_tracking_widget.dart';
import 'package:muscel_meals/services/firebase-database_service.dart';
import 'package:muscel_meals/services/input-field-validation_service.dart';

import '../custom_widgets/custom_button.dart';
import '../custom_widgets/custom_dialog.dart';
import 'home_page.dart';

class BowlSummary extends StatefulWidget {
  final Map bowlIngredients;
  final double price;
  final int kcal;
  final int protein;
  final int fat;
  final int carbohydrates;
  const BowlSummary(
      {required this.price,
      required this.bowlIngredients,
      required this.kcal,
      required this.protein,
      required this.fat,
      required this.carbohydrates,
      super.key});

  @override
  State<BowlSummary> createState() => _BowlSummaryState();
}

class _BowlSummaryState extends State<BowlSummary> {
  List ingredients = [];
  String? location;
  dynamic locationError;
  TimeOfDay? time = TimeOfDay.now();
  int hour = DateTime.now().hour;
  int minute = DateTime.now().minute;

  void mapToList() {
    print(widget.bowlIngredients);
    widget.bowlIngredients.keys.forEach((category) {
      if (widget.bowlIngredients[category].isNotEmpty) {
        print(category);
        ingredients.add({
          'category': category,
          'ingredients': [],
        });
        widget.bowlIngredients[category].keys.forEach((ingredient) {
          ingredients.last['ingredients'].add({
            'name': ingredient,
            'gram': widget.bowlIngredients[category][ingredient],
          });
        });
      }
    });
    print(ingredients);
  }

  @override
  void initState() {
    mapToList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bowl Zusammenfassung'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: DatabaseService().getLocations(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomDropdown((value) {
                        location = value;
                        setState(() {
                          locationError =
                              Validator().locationValidation(location);
                        });
                      }, snapshot.data!, locationError);
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
                const Divider(
                  height: 60,
                  thickness: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Abholzeit:'),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay? timePicker = await showTimePicker(
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                context: context,
                                initialTime: time!,
                                builder: (context, child) {
                                  return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true,
                                          textScaleFactor: 1.1),
                                      child: child!);
                                },
                              );
                              if (timePicker != null) {
                                setState(() {
                                  time = timePicker;
                                });
                              }
                            },
                            child: Text(
                                '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}Uhr'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 60,
                  thickness: 3,
                ),
                CustomTrackingWidget(
                    kcal: widget.kcal,
                    protein: widget.protein,
                    fat: widget.fat,
                    carbohydrates: widget.carbohydrates),
                const Divider(
                  height: 60,
                  thickness: 3,
                ),
                BowlSummaryWidget(
                  bowlIngredients: widget.bowlIngredients,
                  price: widget.price,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                    child: OutlinedButton(
                        child: const Text('Abbrechen'),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                              (route) => false);
                        }),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                    child: OutlinedButton(
                      child: const Text('Bestellen'),
                      onPressed: () async {
                        DateTime chosenTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          time!.hour,
                          time!.minute,
                        );
                        DateTime nowTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          DateTime.now().hour,
                          DateTime.now().minute,
                        );
                        setState(() {
                          locationError = location != null
                              ? null
                              : 'Du musst einen Standort auswählen.';
                        });
                        //print(DateTime.now());
                        if (location != null) {
                          if (nowTime.isBefore(chosenTime) |
                              nowTime.isAtSameMomentAs(chosenTime)) {
                            await DatabaseService().addOrder(
                              widget.bowlIngredients,
                              time!,
                              location!,
                              widget.price,
                              widget.kcal,
                              widget.protein,
                              widget.fat,
                              widget.carbohydrates,
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (route) => false);
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog.CustomDialog('Error',
                                    'Die ausgewählte Abholzeit ist schon vergangen.');
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
