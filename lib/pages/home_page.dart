import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_old_order_widget.dart';
import 'package:muscel_meals/pages/customize-bowl_page.dart';
import 'package:muscel_meals/pages/logged-in-logged-out_page.dart';
import 'package:muscel_meals/services/firebase-auth_service.dart';
import 'package:muscel_meals/services/firebase-database_service.dart';
import 'package:muscel_meals/services/firebase_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> getPreparedBowls() async {
    List bowls = await DatabaseService().getPreparedBowls();
    for (int i = 0; i < bowls.length; i++) {
      bowls[i]['image'] =
          await StorageService().getDownloadURL(bowls[i]['image']);
    }
    return bowls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Hallo, '),
            FutureBuilder(
              future: DatabaseService().getUserName(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.toString());
                } else {
                  return Container(
                    height: 0,
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  //color: Colors.red,
                  child: Text(
                    'Vorbereitete Bowls',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: getPreparedBowls(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: index == 0
                                  ? const EdgeInsets.fromLTRB(16, 8, 16, 8)
                                  : const EdgeInsets.fromLTRB(0, 8, 16, 8),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: const Color(0xffffd7b5),
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 10,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => CustomizeBowl(
                                              bowlIngredients: snapshot
                                                  .data![index]['ingredients'],
                                            ),
                                          ),
                                          (route) => false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20)),
                                              child: Image.network(
                                                snapshot.data![index]['image'],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 8,
                                          ),
                                          Text(
                                            snapshot.data![index]['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  //color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bestellungen',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: DatabaseService().getUserBowls(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: index == 0
                                    ? const EdgeInsets.fromLTRB(16, 8, 16, 8)
                                    : const EdgeInsets.fromLTRB(0, 8, 16, 8),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Material(
                                    color: const Color(0xffffd7b5),
                                    borderRadius: BorderRadius.circular(20),
                                    elevation: 10,
                                    child: CustomOrderWidget(
                                        order: snapshot.data![index]),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('Du hast noch keine Bestellungen'),
                          );
                        }
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
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomizeBowl(bowlIngredients: {})),
                      (route) => false);
                },
                child: Text(
                  'Bowl selbst zusammenstellen',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
