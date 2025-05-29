import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ControlButton extends StatefulWidget {
  const ControlButton({super.key});

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  final dbRef = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> blowSubscription;
  late StreamSubscription<DatabaseEvent> autoSubscription;

  int blowValue = 0;
  bool auto = false;

  @override
  void initState() {
    super.initState();
    blowSubscription = dbRef.child('control/blow').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          blowValue = event.snapshot.value as int;
        });
      }
    });
    autoSubscription = dbRef.child('control/auto').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          auto = event.snapshot.value as bool;
        });
      }
    });
  }

  @override
  void dispose() {
    blowSubscription.cancel(); // Huỷ stream
    autoSubscription.cancel(); // Huỷ stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      foregroundColor: Colors.white,
      backgroundColor: Colors.purpleAccent,
      children: [
        SpeedDialChild(
          child: Icon(Icons.arrow_circle_right_sharp, color: Colors.white),
          backgroundColor:
              (blowValue == 2) ? Color(0xFF56ab2f) : Color(0xFFFF4B2B),
          label: 'Blow Out',
          onTap: () {
            dbRef.child('control/blow').set(blowValue != 2 ? 2 : 0);
            dbRef.child('control/auto').set(false);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.arrow_circle_left_sharp, color: Colors.white),
          backgroundColor:
              (blowValue == 1) ? Color(0xFF56ab2f) : Color(0xFFFF4B2B),
          label: 'Blow In',
          onTap: () {
            dbRef.child('control/blow').set(blowValue != 1 ? 1 : 0);
            dbRef.child('control/auto').set(false);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.power_settings_new, color: Colors.white),
          backgroundColor:
              (auto == true) ? Color(0xFF56ab2f) : Color(0xFFFF4B2B),
          label: 'Auto',
          onTap: () {
            dbRef.child('control/blow').set(0);
            dbRef.child('control/auto').set(!auto);
          },
        ),
      ],
    );
  }
}
