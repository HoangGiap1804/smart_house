import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_house/module/home/widgets/button_action.dart';
import 'package:smart_house/module/home/widgets/my_drawer.dart';
import 'package:smart_house/module/home/widgets/sensor_data.dart';
import 'package:smart_house/module/home/widgets/sensor_day.dart';
import 'package:smart_house/module/home/widgets/sensor_line_chart_day.dart';

class HourSensorPage extends StatefulWidget {
  const HourSensorPage({super.key});

  @override
  State<HourSensorPage> createState() => _HourSensorPageState();
}

class _HourSensorPageState extends State<HourSensorPage> {
  DateTime selectedDate = DateTime.now();

  final List<SensorData> data = [];

  // Hàm mở DatePicker
  Future<List<SensorDay>>? fetchSensorData() async {
    final firestore = FirebaseFirestore.instance;
    final docSnapshot = await firestore.collection('data').doc('hour').get();

    if (!docSnapshot.exists) return [];

    final data = docSnapshot.data();
    if (data == null || data.isEmpty) return [];

    List<SensorDay> sensorList = [];

    // Lặp qua từng giờ
    for (final entry in data.entries) {
      final hour = int.tryParse(entry.key);
      final rawValue = entry.value.toString().split(',');

      if (hour != null && rawValue.length == 3) {
        final temperature = double.tryParse(rawValue[0].trim());
        final humidity = double.tryParse(rawValue[1].trim());
        final ppm = double.tryParse(rawValue[2].trim());

        if (temperature != null && humidity != null && ppm != null) {
          sensorList.add(
            SensorDay(
              hour: hour,
              temperature: temperature,
              humidity: humidity,
              ppm: ppm,
            ),
          );
        }
      }
    }

    // Sắp xếp theo giờ
    sensorList.sort((a, b) => a.hour.compareTo(b.hour));
    return sensorList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lịch sử')),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<SensorDay>>(
              future: fetchSensorData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator()
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data found');
                }

                final data = snapshot.data!;
                return Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 400,
                      child: SensorLineChartDay(data: data, unit: "Minute"),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
