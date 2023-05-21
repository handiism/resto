import 'package:flutter/material.dart';
import 'package:resto/view/currency.dart';
import 'package:resto/view/profile.dart';
import 'package:resto/view/home.dart';
import 'package:resto/view/time.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = const [Home(), Currency(), Time(), Profile()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Resto")),
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) async {
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money,
            ),
            label: "Uang",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer,
            ),
            label: "Waktu",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
