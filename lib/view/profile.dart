import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:resto/model/user.dart';
import 'package:resto/utils/logger.dart';
import 'package:resto/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = const User(
    id: 0,
    username: "",
    password: "",
    message: null,
  );
  bool _isEditing = false;
  TextEditingController controller = TextEditingController();

  Future _getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt("id") ?? 0;
      final dbPath = join(await getDatabasesPath(), "resto.db");
      final db = await openDatabase(dbPath);
      var row = await db.query('users', where: "id = ?", whereArgs: [id]);
      db.close();
      setState(() {
        user = User(
          id: id,
          username: row[0]["username"].toString(),
          password: row[0]["password"].toString(),
          message: row[0]["message"]?.toString(),
        );
        controller.text = user.message.toString();
        logger.d(user);
      });
      controller.text = user.message.toString();
      logger.d(user);
    } catch (e) {
      logger.d(e);
      logger.d('error');
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Kreator"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("Keluar"),
              ),
            ],
            onSelected: (value) async {
              logger.d(value);
              if (value == 0) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Kreator",
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 190.0,
                              height: 190.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      "https://dicoding-web-img.sgp1.cdn.digitaloceanspaces.com/small/avatar/dos:2d1964e11562f8f7873bc48a3a1b3a6320230225114141.png"),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Muhammad Handi Rachmawan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Teknologi Pemrograman Mobile IF-C",
                          ),
                          const Text(
                            "123200125",
                          ),
                          const Text(
                            "Hobi Rebahan",
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (value == 1) {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.remove("id");

                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              }
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                child: Icon(
                  Icons.person,
                  size: 60,
                ),
              ),
              const Divider(
                color: Colors.transparent,
              ),
              Text(
                user.username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const Divider(),
                    const Text(
                      "Kesan Pesan",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      maxLines: 5,
                      enabled: _isEditing,
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          if (_isEditing) {
                            final dbPath =
                                join(await getDatabasesPath(), "resto.db");
                            final db = await openDatabase(dbPath);
                            logger.d(controller.text.toString());
                            var result = await db.update(
                              'users',
                              {
                                'message': controller.text.toString(),
                              },
                              where: 'id = ?',
                              whereArgs: [user.id],
                            );
                            logger.d(result);
                          }

                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        child: Text(
                          _isEditing ? "Simpan" : "Ubah",
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
