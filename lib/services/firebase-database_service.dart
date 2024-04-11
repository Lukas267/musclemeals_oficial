import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muscel_meals/custom_widgets/custom_ingredient.dart';
import 'package:muscel_meals/ingredient.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  Future<List> getUserBowls() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: await FirebaseAuth.instance.currentUser!.uid)
        .get();
    List data = querySnapshot.docs.map((e) => e.data()).toList();
    data.sort((a, b) => (b['timestamp']).compareTo(a['timestamp']));
    return data;
  }

  Future<List> getPreparedBowls() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('prepared_bowls').get();
    List data = querySnapshot.docs.map((e) => e.data()).toList();
    //data.sort((a, b) => (a['id']).compareTo(b['id']));
    return data;
  }

  Future<List<String>> getLocations() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('locations').get();
    final List<String> data = querySnapshot.docs.map((e) => e.id).toList();
    return data;
  }

  void addUserInformation(String name) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'name': name,
    });
  }

  Future addOrder(
    Map bowlIngredients,
    TimeOfDay time,
    String location,
    double price,
    int kcal,
    int protein,
    int fat,
    int carbohydrates,
  ) async {
    try {
      FirebaseFirestore.instance.collection('orders').doc().set(
        {
          'name': await getUserName(),
          'ingredients': bowlIngredients,
          'timestamp': Timestamp.now(),
          'pickUpTimestamp': Timestamp.fromDate(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, time.hour, time.minute),
          ),
          'uid': await FirebaseAuth.instance.currentUser!.uid,
          'location': location,
          'price': price,
          'kcal': kcal,
          'protein': protein,
          'fat': fat,
          'carbohydrates': carbohydrates,
          'complete': false,
        },
      );
      return null;
    } catch (e) {
      return e;
    }
  }

  Future<String> getUserName() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return documentSnapshot.get('name');
  }

  Future<List> getCategories() async {
    List categories = [];
    await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('id', descending: false)
        .get()
        .then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          categories.add(doc.id);
        }
      },
    );
    return categories;
  }

  Future<List> getIngredients() async {
    List categories = [];
    List ingredients = [];
    await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('id', descending: false)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        categories.add(doc.id);
      }
    });
    for (int i = 0; i < categories.length; i++) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categories[i])
          .collection('ingredients')
          .get();
      ingredients.add({
        'category': categories[i],
        'ingredients': querySnapshot.docs.map((e) => e.data()).toList()
      });
    }
    return ingredients;
  }

  Future<List> getBases() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('bases').get();
    List data = querySnapshot.docs.map((e) => e.data()).toList();
    data.sort((a, b) => (a['id']).compareTo(b['id']));
    for (int i = 0; i < data.length; i++) {
      data[i]['gram'] = 0;
    }
    return data;
  }

  Future<List> getToppings() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('toppings').get();
    final List data = querySnapshot.docs.map((e) => e.data()).toList();
    return data;
  }
}
