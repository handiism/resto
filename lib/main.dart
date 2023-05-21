import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:resto/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:resto/view/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool exist = prefs.containsKey("id");

  runApp(RestoApp(
    exist: exist,
  ));

  final db = await openDatabase(
    join(await getDatabasesPath(), "resto.db"),
    onCreate: (db, version) async {
      await db.transaction(
        (tx) async {
          await tx.execute("""
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            message TEXT NOT NULL DEFAULT ''
          );""");

          await tx.execute("""
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            restoId TEXT NOT NULL UNIQUE,
            userId INTEGER NOT NULL,
            FOREIGN KEY (userId) REFERENCES users(id)
          );""");
        },
      );
    },
    version: 1,
  );
  db.close();
}

class RestoApp extends StatelessWidget {
  final bool exist;

  const RestoApp({super.key, required this.exist});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resto',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData.light(useMaterial3: true),
      home: exist ? const NavBar() : const Login(),
    );
  }
}
