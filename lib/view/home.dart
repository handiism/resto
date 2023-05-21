import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:resto/model/resraurant.dart';
import 'package:resto/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isFavorite = false;
  bool _filtered = false;
  List<Restaurant> restaurants = [];

  Future _getData() async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://restaurant-api.dicoding.dev/list",
        ),
      );

      Map<String, dynamic> json = jsonDecode(response.body);

      List list = json["restaurants"];
      restaurants.clear();
      for (var l in list) {
        var restaurant = Restaurant.fromJson(l);
        restaurants.add(restaurant);
      }

      if (_filtered) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int id = prefs.getInt("id") ?? 0;

        final dbPath = join(await getDatabasesPath(), "resto.db");
        final db = await openDatabase(dbPath);
        var rows = await db.rawQuery(
          "SELECT * FROM favorites WHERE userId = ?",
          [id],
        );
        final restoIds = rows.map((e) => e['restoId'].toString()).toList();

        restaurants =
            restaurants.where((e) => restoIds.contains(e.id)).toList();

        logger.d(restoIds);
      } else {}

      logger.d(restaurants.length);
    } catch (e) {
      logger.d(e);
      logger.d('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_filtered ? "Restoran Favorit" : "Restoran"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _filtered = !_filtered;
                  });
                },
                icon: Icon(_filtered ? Icons.filter_alt : Icons.filter_alt_off))
          ]),
      body: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    leading: Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://restaurant-api.dicoding.dev/images/small/${restaurants[index].pictureId}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(restaurants[index].name),
                    subtitle: Text(
                      restaurants[index].description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int id = prefs.getInt("id") ?? 0;

                    final dbPath = join(await getDatabasesPath(), "resto.db");
                    final db = await openDatabase(dbPath);
                    var rows = await db.rawQuery(
                      "SELECT * FROM favorites WHERE restoId = ? AND userId = ?",
                      [restaurants[index].id, id],
                    );
                    setState(() {
                      _isFavorite = rows.isNotEmpty;
                    });

                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(restaurants[index].name),
                              actions: [
                                IconButton(
                                  onPressed: () async {
                                    if (_isFavorite) {
                                      await db.delete(
                                        "favorites",
                                        where: 'restoId = ? AND userId = ?',
                                        whereArgs: [restaurants[index].id, id],
                                      );

                                      setState(() {
                                        _isFavorite = false;
                                      });
                                    } else {
                                      await db.insert("favorites", {
                                        'restoId': restaurants[index].id,
                                        'userId': id
                                      });

                                      setState(() {
                                        _isFavorite = true;
                                      });
                                    }
                                  },
                                  icon: Icon(_isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                )
                              ],
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Divider(
                                      color: Colors.transparent,
                                      height: 5,
                                    ),
                                    Image.network(
                                        "https://restaurant-api.dicoding.dev/images/small/${restaurants[index].pictureId}"),
                                    const Divider(
                                      color: Colors.transparent,
                                      height: 5,
                                    ),
                                    Text(
                                      restaurants[index].description,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Icon(
                  Icons.signal_cellular_connected_no_internet_0_bar,
                ),
              ),
              Center(child: Text("Tidak Ada Koneksi Internet"))
            ],
          );
        },
      ),
    );
  }
}
