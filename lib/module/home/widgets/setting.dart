import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_house/module/home/widgets/textfield_change.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final dbRef = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> lowSubscription;
  late StreamSubscription<DatabaseEvent> highSubscription;
  late StreamSubscription<DatabaseEvent> ppmSubscription;
  final TextEditingController temlowController = TextEditingController();
  final TextEditingController temhighController = TextEditingController();
  final TextEditingController ppmController = TextEditingController();
  final TextEditingController temmidController = TextEditingController();
  double temlow = 30;
  double temhigh = 40;
  double temmid = 40;
  double ppm = 600;

  @override
  void initState() {
    super.initState();
    ppmSubscription = dbRef.child('control/ppm').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          ppm = (event.snapshot.value as num).toDouble();
          ppmController.text = ppm.toString();
        });
      }
    });
    lowSubscription = dbRef.child('control/temlow').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          temlow = (event.snapshot.value as num).toDouble();
          temlowController.text = temlow.toString();
        });
      }
    });
    highSubscription = dbRef.child('control/temhigh').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          temhigh = (event.snapshot.value as num).toDouble();
          temhighController.text = temhigh.toString();
        });
      }
    });
    highSubscription = dbRef.child('control/temmid').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          temmid = (event.snapshot.value as num).toDouble();
          temmidController.text = temmid.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    ppmSubscription.cancel(); // Huỷ stream
    lowSubscription.cancel(); // Huỷ stream
    highSubscription.cancel(); // Huỷ stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        TextfieldChange(
          controller: ppmController,
          text: "PPM",
          onTap: (){
              final input = ppmController.text;
              final temp = int.tryParse(input);
              if (temp != null) {
                dbRef.child('control/ppm').set(temp);
              } else {
                print("Vui lòng nhập số hợp lệ.");
              }
          },
        ),
        SizedBox(height: 10),
        TextfieldChange(
          controller: temhighController,
          text: "High Temperature",
          onTap: (){
              final input = temhighController.text;
              final temp = int.tryParse(input);
              if (temp != null) {
                dbRef.child('control/temhigh').set(temp);
              } else {
                print("Vui lòng nhập số hợp lệ.");
              }
          },
        ),
        SizedBox(height: 10),
        TextfieldChange(
          controller: temmidController,
          text: "Middle Temperature",
          onTap: (){
              final input = temmidController.text;
              final temp = int.tryParse(input);
              if (temp != null) {
                dbRef.child('control/temmid').set(temp);
              } else {
                print("Vui lòng nhập số hợp lệ.");
              }
          },
        ),
        SizedBox(height: 10),
        TextfieldChange(
          controller: temlowController,
          text: "Low Temperature",
          onTap: (){
              final input = temlowController.text;
              final temp = int.tryParse(input);
              if (temp != null) {
                dbRef.child('control/temlow').set(temp);
              } else {
                print("Vui lòng nhập số hợp lệ.");
              }
          },
        ),
      ],
    );
  }
}
