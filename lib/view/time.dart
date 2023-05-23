import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  Location location = tz.UTC;
  DateTime datetime = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tz.initializeTimeZones();

        datetime = tz.TZDateTime.now(location);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Waktu"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: SizedBox(
                    height: 100.0,
                    child: Center(
                      child: Text(
                        '${datetime.year.toString()}/${datetime.month.toString().padLeft(2, '0')}/${datetime.day.toString().padLeft(2, '0')} - ${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}:${datetime.second.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () {
                    tz.initializeTimeZones();
                    setState(
                      () {
                        location = tz.getLocation("Asia/Jakarta");
                        datetime = tz.TZDateTime.now(location);
                      },
                    );
                  },
                  child: const Text("Asia/Jakarta"),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () {
                    tz.initializeTimeZones();
                    setState(() {
                      location = tz.getLocation("Asia/Makassar");
                      datetime = tz.TZDateTime.now(location);
                    });
                  },
                  child: const Text("Asia/Makassar"),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () {
                    tz.initializeTimeZones();
                    setState(() {
                      location = tz.getLocation("Asia/Jayapura");
                      datetime = tz.TZDateTime.now(location);
                    });
                  },
                  child: const Text("Asia/Jayapura"),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                ElevatedButton(
                  onPressed: () {
                    tz.initializeTimeZones();
                    setState(() {
                      location = tz.getLocation("Europe/London");
                      datetime = tz.TZDateTime.now(location);
                    });
                  },
                  child: const Text("Europe/London"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
