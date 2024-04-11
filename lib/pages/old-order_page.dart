import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_button.dart';
import 'package:muscel_meals/custom_widgets/custom_ingredient_summary_widget.dart';
import 'package:muscel_meals/custom_widgets/custom_single_tracking_widget.dart';
import 'package:muscel_meals/custom_widgets/custom_tracking_widget.dart';
import 'package:muscel_meals/pages/customize-bowl_page.dart';
import 'package:muscel_meals/services/firebase-database_service.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class OrderPage extends StatefulWidget {
  final Timestamp timestamp;
  final double price;
  final int kcal;
  final int protein;
  final int fat;
  final int carbs;
  final Map bowlIngredients;
  final String location;

  const OrderPage(
      {required this.timestamp,
      required this.price,
      required this.kcal,
      required this.protein,
      required this.fat,
      required this.carbs,
      required this.bowlIngredients,
      required this.location,
      Key? key})
      : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bestellung'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CustomTrackingWidget(
                      kcal: widget.kcal,
                      protein: widget.protein,
                      fat: widget.fat,
                      carbohydrates: widget.carbs),
                  const Divider(
                    thickness: 3,
                    height: 60,
                  ),
                  BowlSummaryWidget(
                    bowlIngredients: widget.bowlIngredients,
                    price: widget.price,
                  ),
                ],
              ),
              const Divider(
                thickness: 3,
                height: 60,
              ),
              Column(
                children: [
                  const Divider(
                    height: 0,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const VerticalDivider(
                          width: 0,
                        ),
                        const Expanded(
                          flex: 1,
                          child: CustomSingleTrackingWidget(text: 'Standort'),
                        ),
                        const VerticalDivider(
                          width: 0,
                        ),
                        Expanded(
                          flex: 1,
                          child:
                              CustomSingleTrackingWidget(text: widget.location),
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
              ),
              const Divider(
                thickness: 3,
                height: 60,
              ),
              SfBarcodeGenerator(
                value: FirebaseAuth.instance.currentUser!.uid,
                symbology: QRCode(),
                showValue: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 12,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => CustomizeBowl(
                          bowlIngredients: widget.bowlIngredients),
                    ),
                    (route) => false);
              },
              child: const Text('Configure again'),
            ),
          ),
        ),
      ),
    );
  }
}
