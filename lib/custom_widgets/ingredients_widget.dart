import 'package:flutter/material.dart';

import 'custom_ingredient.dart';
/*
class FutureWidget extends StatefulWidget {
  final Future future;
  final Map prepared;
  final Function valueChanged;
  final String category;
  final int categoryIndex;

  const FutureWidget(
      {required this.future,
      required this.prepared,
      required this.valueChanged,
      required this.category,
      required this.categoryIndex,
      super.key});

  @override
  State<FutureWidget> createState() => _FutureWidgetState();
}

class _FutureWidgetState extends State<FutureWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //widget.valueChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(snapshot.data![widget.categoryIndex]['category']),
              ListView.builder(
                shrinkWrap: true,
                itemCount:
                    snapshot.data![widget.categoryIndex]['ingredients'].length,
                itemBuilder: (context, index) {
                  return CustomIngredientWidget(
                    categoryIndex: widget.categoryIndex,
                    category: snapshot.data![widget.categoryIndex]['category'],
                    name: snapshot.data![widget.categoryIndex]['ingredients']
                        [index]['name'],
                    bowlIngredients: widget.prepared,
                    snapshot: snapshot,
                    index: index,
                    init: () {
                      //changeValues(snapshot);
                    },
                    onChanged: widget.valueChanged,
                  );
                },
              ),
            ],
          );
        } else {
          return const Text('Error');
        }
      },
    );
    ;
  }
}
*/